//
//  SuggestedDrinkTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/18/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SuggestedDrinkTableViewCell: UITableViewCell {

    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    
    
    
    func update(ingredient: Ingredient){
            DispatchQueue.main.async {
        self.ImageView.image = ingredient.photoImage
        self.titleText.text = ingredient.name
        }
    }
    
    var ingredient: Ingredient? {
        didSet {
            guard let ingredient = ingredient else { return }
            update(ingredient: ingredient)
        }
    }
}
