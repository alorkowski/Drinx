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
        guard let cocktail = cocktail,
            let imageURLs = cocktail.imageURLs.first else { return }
        
        DispatchQueue.main.async {
            ImageController.getImage(forURL: imageURLs, completion: { (image) in
                self.imageCell.image = image
            })
        }
    }
}
