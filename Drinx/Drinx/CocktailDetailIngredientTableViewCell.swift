//
//  CocktailDetailIngredientTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CocktailDetailIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientsCell: UILabel!
    
    var cocktail: Cocktail? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard let cocktail = cocktail else { return }
        
        ingredientsCell.text = cocktail.ingredients.joined(separator: ", ")
    }
}
