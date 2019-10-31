//
//  CabinetController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

final class CabinetController {
    let ingredientIDsKey = "ingredientIDs"
    
    static let shared = CabinetController()
    var myCabinet = Cabinet()
    var cabinetHasBeenUpdated: Bool = false
    
    func saveMyCabinetToUserDefaults() {
        UserDefaults.standard.set(myCabinet.ingredientIDs, forKey: ingredientIDsKey)
    }

    func getMyIngredientsFromUserDefaults() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        guard let myIngredientsStringAray = UserDefaults.standard.array(forKey: ingredientIDsKey) as? [String] else { return [] }
        guard let path = Bundle.main.path(forResource: "ingredients", ofType: "json") else { return [] }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            let ingredientsDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: String]]
            for name in myIngredientsStringAray {
                let ingredient = Ingredient(name: name)
                ingredients.append(ingredient)
            }
        } catch {
            print(error.localizedDescription)
            return []
        }
        return ingredients
    }
}
