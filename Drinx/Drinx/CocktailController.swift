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
    
    let cloudKitManager = CloudKitManager()
    
    var cocktails: [Cocktail] = []
    
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
}
