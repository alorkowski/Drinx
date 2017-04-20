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
    
    private let savedCocktailsKey = "savedCocktails"
    
    static let shared = CocktailController()
    
    var suggestedResultsCursor: CKQueryCursor?
    
    let cloudKitManager = CloudKitManager()
    
    var cocktails: [Cocktail] = []
    
    var savedCocktails: [Cocktail] = []
    
    var suggestedCocktails: [Cocktail] = []
    
    var mockIngredients: [String] = ["Vodka", "Ice", "Orange juice", "Gin", "Schnapps" , "Cider" , "Aftershock" , "Sprite" , "Rumple Minze", "Peach Vodka" , "Ouzo" , "Coffee" , "Spiced rum" , "Water" , "Espresso" , "Angelica root" , "Condensed milk" , "Honey" , "Whipping cream"]
    
    
    // MARK: - UserDefaults
    
    func saveMyFavoriteCocktailsToUserDefaults() {
        var cocktailIDStrings: [String] = []
        for cocktail in savedCocktails {
            guard let idString = cocktail.apiID else { break }
            cocktailIDStrings.append(idString)
        }
        UserDefaults.standard.set(cocktailIDStrings, forKey: savedCocktailsKey)
    }
    
    func fetchMyFavoriteCocktailsFromUserDefaults() -> [Cocktail] {
        guard let cocktailIDStrings = UserDefaults.standard.value(forKey: savedCocktailsKey) as? [String] else { return [] }
        guard let cocktailDictionaries = JSONController.shared.getCocktailDictionaryArray() else { return [] }
        var cocktails: [Cocktail] = []
        let group = DispatchGroup()
        var groupCount = 0
        for id in cocktailIDStrings {
            for cocktail in cocktailDictionaries {
                guard let drinkID = cocktail["idDrink"] as? String else { break }
                if drinkID == id {
                    guard let ct = Cocktail(cocktailDictionary: cocktail) else { break }
                    if ct.imageURLs[0] != "" {
                        let ckm = CloudKitManager()
                        if let apiID = ct.apiID {
                            group.enter()
                            let predicate = NSPredicate(format: "%@ = apiID", apiID)
                            let query = CKQuery(recordType: "Cocktail", predicate: predicate)
                            let queryOperation = CKQueryOperation(query: query)
                            queryOperation.recordFetchedBlock = { (record) -> Void in
                                if let tempCocktail = Cocktail(record: record) {
                                    if !cocktails.contains(tempCocktail) {
                                        cocktails.insert(tempCocktail, at: 0)
                                    }
                                    group.leave()
                                    groupCount -= 1
                                    print(groupCount)
                                    
                                }
                            }
                            ckm.publicDatabase.add(queryOperation)
                        } else {
                            if !cocktails.contains(ct) {
                                cocktails.append(ct)
                            }
//                            group.leave()
//                            groupCount -= 1
//                            print(groupCount)
                        }
                    } else {
                        if !cocktails.contains(ct) {
                        cocktails.append(ct)
                        }
                    }
                }
            }
        }
        group.wait()
        return cocktails
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
