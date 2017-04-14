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
    
    func update(ingredient: Ingredient){
        ImageView.image = ingredient.photoImage
        
    }
    
    var ingredient: Ingredient? {
        didSet {
            guard let ingredient = ingredient else { return }
            update(ingredient: ingredient)
        }
    }
}
