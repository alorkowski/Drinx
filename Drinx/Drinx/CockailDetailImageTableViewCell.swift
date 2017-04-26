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
    
    override func awakeFromNib() {
        
//        self.cell.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, tableInsets)
    }
    
    var cocktail: Cocktail? {
        didSet {
            updateCell()
        }
    }
    
    func updateCell() {
        guard let cocktail = cocktail else { updateCell(); return }
        if let image = cocktail.image {
            self.imageCell?.image = image
        } else {
            if let image = UIImage(named: cocktail.ingredients[0]) {
                self.imageCell?.image = image
            } else if let image = UIImage(named: cocktail.ingredients[1]) {
                self.imageCell?.image = image
            }
        }
    }
}
