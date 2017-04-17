//
//  ImageController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class ImageController {
    
    static func getImage(forURL url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { completion(nil); return }
        
        NetworkController.performRequest(forURL: url, httpMethod: .get) { (data, error) in
            if let error = error {
                print("Error performing network request: \(error.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
            }
            
            DispatchQueue.main.async { completion(image) }
        }
    }
}
