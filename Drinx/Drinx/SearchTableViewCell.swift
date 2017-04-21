//
//  SearchTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var drinkNameText: UILabel!
    
    
    func update(cocktail: Cocktail){

        drinkNameText.text = cocktail.name
        
        if cocktail.image != nil {
            ImageView.image = cocktail.image
        } else {
            if let firstIngredientName = cocktail.ingredients.first {
                ImageView.image = UIImage(named: firstIngredientName)
            }
        }
        
        
    }
    
    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }
}
