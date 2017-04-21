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
            let ingredientLastIndex = cocktail.ingredients.count - 1
            
            if let image = UIImage(named: cocktail.ingredients[0]) {
                ImageView.image = image
            } else if let image = UIImage(named: cocktail.ingredients[1]) {
                ImageView.image = image
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


