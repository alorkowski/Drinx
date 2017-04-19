//
//  SuggestedTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/19/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SuggestedTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var drinkLabelView: UILabel!
    
    func update(ingredient: Ingredient){
        ImageView.image = ingredient.photoImage
        drinkLabelView.text = ingredient.namegit 
        
    }
    
    var ingredient: Ingredient? {
        didSet {
            guard let ingredient = ingredient else { return }
            update(ingredient: ingredient)
        }
    }

}
