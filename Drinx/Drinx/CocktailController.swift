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
    var suggestedResultsCursor: CKQueryOperation.Cursor?
    let cloudKitManager = CloudKitManager()
    var cocktails: [Cocktail] = []
    var savedCocktails: [Cocktail] = []
    var suggestedCocktails: [Cocktail] = []

    var sampleSavedCocktails: [Cocktail] {
        return CocktailController.getRandomCocktails(numberOfCocktailsToGet: 2)
    }

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

    func fetchMyFavoriteCocktailsFromUserDefaults() {
        guard let cocktailIDStrings = UserDefaults.standard.value(forKey: savedCocktailsKey) as? [String] else { return }
        guard let cocktailDictionaries = JSONController.shared.getCocktailDictionaryArray() else { return }
        var cocktails: [Cocktail] = []
        for id in cocktailIDStrings {
            for cocktail in cocktailDictionaries {
                guard let drinkID = cocktail["idDrink"] as? String else { break }
                if drinkID == id {
                    guard let ct = Cocktail(cocktailDictionary: cocktail) else { break }
                    cocktails.append(ct)
                }
            }
        }
        self.savedCocktails = cocktails
    }

    // Save a cocktail to cloudkit
    func saveCocktailToCloudKit(cocktail: Cocktail,
                                completion: @escaping(Bool) -> Void) {
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

    func fetchRecords(matchingIngredientList ingredients: [Ingredient],
                      completion: @escaping ([CKRecord]) -> Void) {
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

    func getCocktailDictionaryArray(completion: () -> Void) {
        guard let path = Bundle.main.path(forResource: "CocktailRecipes", ofType: "json") else {return}
        do {

            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return }
            let cocktailsArray = jsonArray.compactMap( { Cocktail(cocktailDictionary: $0)} )
            self.cocktails = cocktailsArray
            completion()
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }

    func searchCocktails(for searchTerm: String,
                         perRecordCompletion: @escaping (Cocktail) -> Void,
                         completion: (() -> Void)) {
        for cocktail in self.cocktails {
            let lowercasedCocktailIngredients = cocktail.ingredients.joined(separator: " ")
            if cocktail.name.lowercased().contains(searchTerm.lowercased()) {
                DispatchQueue.main.async {
                    perRecordCompletion(cocktail)
                }
            } else if lowercasedCocktailIngredients.contains(searchTerm.lowercased()) {
                DispatchQueue.main.async {
                    perRecordCompletion(cocktail)
                }
            }
        }
        completion()
    }
}

extension CocktailController {
    static func getRandomCocktails(numberOfCocktailsToGet: Int) -> [Cocktail] {
        var randomCocktails: [Cocktail] = []
        for _ in 1...numberOfCocktailsToGet {
            let randomNumber = Int(arc4random_uniform(UInt32(CocktailController.shared.cocktails.count)))
            let cocktail = CocktailController.shared.cocktails[randomNumber]
            randomCocktails.append(cocktail)
        }
        return randomCocktails
    }
}
