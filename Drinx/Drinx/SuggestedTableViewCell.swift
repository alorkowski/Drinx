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
    
    func update(cocktail: Cocktail){
        if let image = cocktail.image {
            ImageView.image = image
        } else {
            ImageView.image = UIImage(named: cocktail.ingredients[0])
        }
        drinkLabelView.text = cocktail.name
        
    }
    
    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }
    
}
