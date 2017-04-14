//
//  CocktailController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation
import CloudKit

class CocktailController {
    
    static let shared = CocktailController()
    
    var suggestedResultsCursor: CKQueryCursor?
    
    let cloudKitManager = CloudKitManager()
    
    var cocktails: [Cocktail] = []
    
    var suggestedCocktails: [Cocktail] = []
    
    // Create a cocktail
    func createCocktail(dictionary: [String: Any]) {
        guard let cocktail = Cocktail(cocktailDictionary: dictionary)
            else { return }
        cocktails.append(cocktail)
        
        saveCocktailToCloudKit(cocktail: cocktail) { (success) in
            if success {
                print("success")
            } else {
                print("crap")
            }
        }
    }
    
    // Save a cocktail to cloudkit
    func saveCocktailToCloudKit(cocktail: Cocktail, completion: @escaping(Bool) -> Void) {
        let record = CKRecord(cocktail: cocktail)
        
        cloudKitManager.saveRecord(record) { (returnedRecord, error) in
            if let error = error {
                NSLog("There was an error saving record to cloudKit: \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
            return
        }
    }
    
    func fetchRecords(matchingIngredientList ingredients: [Ingredient], completion: @escaping ([CKRecord]) -> Void) {
        var ckRecords: [CKRecord] = []
        let predicate = NSPredicate(format: "%@ CONTAINS ingredients", ingredients)
        let query = CKQuery(recordType: "Cocktail", predicate: predicate)
        let queryOperation = CKQueryOperation(query: query)
        if let cursor = self.suggestedResultsCursor {
            queryOperation.cursor = cursor
        }
        queryOperation.resultsLimit = 20
        queryOperation.recordFetchedBlock = { (record) -> Void in
            ckRecords.append(record)
            if let cocktail = Cocktail(record: record) {
                var ids: [String] = []
                // for loop to check ids in array of suggested cocktails
                // assign each id in the array to var ids
                //if ids does not contain cocktail.id, append it to the array of suggested cocktails
            }
        }
        queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
            if let error = error {
                print("There was an error fetching suggested cocktails\nError: \(error)")
            }
            if let cursor = cursor {
                self.suggestedResultsCursor = cursor
            }
        }
        
        queryOperation.completionBlock = { () -> Void in
            completion(ckRecords)
        }
        CKContainer.default().publicCloudDatabase.add(queryOperation)
    }
}
