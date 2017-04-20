//
//  SearchTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
//    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var drinkNameText: UILabel!
    
    
    func update(cocktail: Cocktail){
//        ImageView.image = cocktail.image
        drinkNameText.text = cocktail.name
        
    }
    
    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }
}
