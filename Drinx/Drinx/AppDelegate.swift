//
//  AppDelegate.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit
import CloudKit
import Darwin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
//        return generateCloudKitRecords(jsonDictionaryToUse: "CocktailRecipes")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}



// MARK: - function used to take cocktail dictionaries from CocktailRecipes.json, turn them into cocktails, then into CKRecords, then save them to CloudKit.

func generateCloudKitRecords(jsonDictionaryToUse: String) -> Bool {
    guard let bundlePath = Bundle.main.path(forResource: jsonDictionaryToUse, ofType: "json")
        else { return false }
    do {
        let data = try Data(contentsOf: URL(fileURLWithPath: bundlePath), options: .alwaysMapped)
        let jsonArray = try
            JSONSerialization.jsonObject(with: data, options: .allowFragments)
        
        guard let jsonArrayOfDictionaries = jsonArray as? [[String:Any]]
            else { return false }
        print("json dictionary successfully created")
        let cocktails = jsonArrayOfDictionaries.flatMap { Cocktail(cocktailDictionary: $0) }
        print("\(cocktails.count)")
        
        var cocktailsWithImages: [Cocktail] = []
        
        let group = DispatchGroup()
        
        var groupCount = 0
        
        for cocktail in cocktails {
            group.enter()
            groupCount += 1
            print("\(groupCount)")
            
            if let imageURL = cocktail.imageURLs.first {
                // fetch image
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
                        print("\(groupCount)")
                        group.leave()
                    } else {
                        cocktailsWithImages.append(cocktail)
                        groupCount -= 1
                        print("\(groupCount)")
                        group.leave()
                    }
                })
            } else {
                groupCount -= 1
                print("\(groupCount)")
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
//                        print(record?["photoData"])
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
    } catch {
        NSLog(error.localizedDescription)
        return false
    }
    
}


