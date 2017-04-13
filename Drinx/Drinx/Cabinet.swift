//
//  Cabinet.swift
//  Drinx
//
//  Created by Angela Montierth on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

class Cabinet {
    
    
    
    var myIngredients: [Ingredient] = []
    var ingredientIDs: [String] {
        var ckRecordList: [String] = []
        for ingredient in myIngredients {
            ckRecordList.append(ingredient.name)
        }
        return ckRecordList
    }
    
}
