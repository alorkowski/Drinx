//
//  CockailDetailImageTableViewCell.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CockailDetailImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    
    var cocktail: Cocktail? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard let cocktail = cocktail, let _ = imageView else { updateCell(); return }
        if let image = cocktail.image {
            self.imageView?.image = image
        } else {
            self.imageView?.image = UIImage(named: cocktail.ingredients[0])
        }
    }
}
