//
//  SuggestedTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/19/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SuggestedTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkLabelView: UILabel!

    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }
    
    func update(cocktail: Cocktail) {
        if let image = cocktail.image {
            drinkImageView.image = image
        } else {
            drinkImageView.image = UIImage(named: cocktail.ingredients[0])
        }
        drinkLabelView.text = cocktail.name
    }
}
