//
//  Ingredient.swift
//  Drinx
//
//  Created by Angela Montierth on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

import UIKit
import CloudKit

class Ingredient: Equatable {
    
    static let photoImageKey = "photoImage"
    
    
    var photoImage: UIImage? = nil
    let name: String
    
    
    init(name: String) {
        self.name = name
        guard let image = UIImage(named: name) else {return}
        self.photoImage  = image
        
    }
    
    
}

extension Ingredient {
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name
    }
}

