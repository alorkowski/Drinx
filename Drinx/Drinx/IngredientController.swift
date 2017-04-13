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
    var ingredints = [Ingredient]()
    
    func create(item: String){
    let ingredent =  Ingredient(name: item)
       ingredints.append(ingredent)
    
    }


}
