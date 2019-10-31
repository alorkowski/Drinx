//
//  SavedDrinksTableViewCell.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/20/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class SavedDrinksTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!

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
        drinkLabel.text = cocktail.name
    }
}
