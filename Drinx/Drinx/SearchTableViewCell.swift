//
//  SearchTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var drinkImageView: UIImageView!
    @IBOutlet weak var drinkNameText: UILabel!

    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }

    func update(cocktail: Cocktail) {
        drinkNameText.text = cocktail.name
        if cocktail.image != nil {
            drinkImageView.image = cocktail.image
        } else {
            if let image = UIImage(named: cocktail.ingredients[0]) {
                drinkImageView.image = image
            } else if let image = UIImage(named: cocktail.ingredients[1]) {
                drinkImageView.image = image
            }
        }
    }
}
