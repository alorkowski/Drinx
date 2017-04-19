//
//  MyCabinetCollectionViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class MyCabinetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: Ingredient? {
        didSet {
            self.updateViews()
        }
    }
    
    func updateViews() {
        if let ingredient = ingredient {
            self.imageView.image = ingredient.photoImage
            self.ingredientLabel.text = ingredient.name
        }
//        self.reloadInputViews()
    }
}
