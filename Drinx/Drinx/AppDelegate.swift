//
//  AppDelegate.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit
import CloudKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // return generateCloudKitRecords(jsonDictionaryToUse: "CocktailRecipes")
        return true
    }
}

/* MARK: - Cloud Kit utility functions
 * Function used to take cocktail dictionaries from CocktailRecipes.json,
 * turn them into cocktails, then into CKRecords, then save them to CloudKit.
 */
enum CloudKitError: Error {
    case downloadError
    case serializationError
}

private func serializeData(in bundlePath: String) -> Result<Any, CloudKitError> {
    let bundle = URL(fileURLWithPath: bundlePath)
    guard let data = try? Data(contentsOf: bundle, options: .alwaysMapped)
        else { return .failure(.downloadError) }
    guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        else { return .failure(.serializationError) }
    return .success(jsonArray)
}

func generateCloudKitRecords(jsonDictionaryToUse: String) -> Bool {
    guard let bundlePath = Bundle.main.path(forResource: jsonDictionaryToUse, ofType: "json") else { return false }
    let jsonArray: Any
    switch serializeData(in: bundlePath) {
    case .success(let data):
        jsonArray = data
    case .failure(let error):
        print(error.localizedDescription)
        return false
    }
    guard let jsonArrayOfDictionaries = jsonArray as? [[String:Any]] else { return false }
    let cocktails = jsonArrayOfDictionaries.compactMap { Cocktail(cocktailDictionary: $0) }
    var cocktailsWithImages: [Cocktail] = []
    let group = DispatchGroup()
    var groupCount = 0
    for cocktail in cocktails {
        group.enter()
        groupCount += 1
        if let imageURL = cocktail.imageURLs.first {
            ImageController.getImage(forURL: imageURL, completion: { (returnedImage) in
                if cocktailsWithImages.count % 10 == 0 {
                    print(cocktailsWithImages.count)
                }
                if let image = returnedImage {
                    var tempCocktail = cocktail
                    tempCocktail.image = image
                    cocktailsWithImages.append(tempCocktail)
                    usleep(1500000)
                    groupCount -= 1
                    group.leave()
                } else {
                    cocktailsWithImages.append(cocktail)
                    groupCount -= 1
                    group.leave()
                }
            })
        } else {
            groupCount -= 1
            group.leave()
        }
    }

    group.notify(queue: DispatchQueue.main, execute: {
        var arrayOfArrayOfCKRecords: [[CKRecord]] = []
        var tempArray: [CKRecord] = []

        for cocktail in cocktailsWithImages {
            let record = CKRecord(cocktail: cocktail)
            tempArray.append(record)
            if jsonDictionaryToUse == "CocktailTestRecipes" {
                if tempArray.count == 4 {
                    arrayOfArrayOfCKRecords.append(tempArray)
                    tempArray = []
                    print("block at index \(arrayOfArrayOfCKRecords.count - 1) saved to array of arrays")
                }
            }
            let cocktailsWithImagesCount = cocktailsWithImages.count
            let arraysMinus1 = cocktailsWithImagesCount / 100
            let countForLastArray = cocktailsWithImagesCount % 100
            if arrayOfArrayOfCKRecords.count == arraysMinus1 && tempArray.count == countForLastArray {
                arrayOfArrayOfCKRecords.append(tempArray)
                tempArray = []
                print("block at index \(arrayOfArrayOfCKRecords.count - 1) saved to array of arrays. This is the last block. :-)")
            }
            if tempArray.count == 100 {
                arrayOfArrayOfCKRecords.append(tempArray)
                tempArray = []
                print("block at index \(arrayOfArrayOfCKRecords.count - 1) saved to array of arrays")
            }
        }

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        for (index, array) in arrayOfArrayOfCKRecords.enumerated() {
            let operation = BlockOperation(block: {
                let ckShared = CloudKitManager()
                ckShared.saveRecords(array, perRecordCompletion: { (record, error) in
                }, completion: { (record, error) in
                    if error != nil {
                        NSLog("There was an error saving records for the block at index \(index). The error was \(error?.localizedDescription)")
                    } else {
                        NSLog("Successfully saved block of records at index \(index)")
                    }
                })
            })
            queue.addOperation(operation)
        }
    })
    return true
}
