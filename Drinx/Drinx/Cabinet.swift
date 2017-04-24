//
//  Cabinet.swift
//  Drinx
//
//  Created by Angela Montierth on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

class Cabinet {
    
    static let sampleIngredientStrings = ["Gin" ,
                                  "Scotch" ,
                                  "Triple sec" ,
                                  "Brandy" ,
                                  "Coffee liqueur" ,
                                  "Rum" ,
                                  "Sugar" ,
                                  "Ice" ,
                                  "Lemon" ,
                                  "Bourbon" ,
                                  "Vodka" ,
                                  "Tequila" ,
                                  "Lime juice" ,
                                  "Egg" ,
                                  "Salt" ,
                                  "Carbonated water" ,
                                  "Lemon peel" ,
                                  "Apple juice" ,
                                  "Orange juice" ,
                                  "Brown sugar" ,
                                  "Milk" ,
                                  "Egg yolk" ,
                                  "Lemon juice" ,
                                  "Soda water" ,
                                  "Whisky" ,
                                  "Coca-Cola"]
    
    var sampleIngredients: [Ingredient] {
        var ingredients: [Ingredient] = []
        for ingredientString in Cabinet.sampleIngredientStrings {
            ingredients.append(Ingredient(name: ingredientString))
        }
        return ingredients
    }
    
    var myIngredients: [Ingredient] = []

    var ingredientIDs: [String] {
        var ckRecordList: [String] = []
        for ingredient in myIngredients {
            ckRecordList.append(ingredient.name)
        }
        return ckRecordList
    }
    
}
