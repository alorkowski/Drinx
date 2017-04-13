//
//  IngredientController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation


class IngredientController {

    static let share = IngredientController()
    var ingredients = [Ingredient]()
    
    func create(item: String){
    let ingredient =  Ingredient(name: item)
       ingredients.append(ingredient)
    
    }


}git 
