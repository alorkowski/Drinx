//
//  IngredientsSearchResultsTableViewCell.swift
//  Drinx
//
//  Created by Angela Montierth on 4/19/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class IngredientsSearchResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!

    var ingredient: Ingredient? {
        didSet {
            updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }

    func updateViews() {
        if let ingredient = ingredient {
            self.ingredientLabel.text = ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines)
            DispatchQueue.main.async {
                self.imageLabel.image = ingredient.photoImage
            }
        }
        reloadInputViews()
    }
}
