import UIKit
import CloudKit

final class Ingredient: Equatable {
    static let photoImageKey = "photoImage"
    var photoImage: UIImage? = nil
    let name: String

    init(name: String) {
        self.name = name
        if let image = UIImage(named: name) {
            self.photoImage  = image
        }
        if let image = UIImage(named: name.capitalized) {
            self.photoImage = image
        }
        if let image = UIImage(named: name.lowercased()) {
            self.photoImage = image
        }
        let nameArray = name.components(separatedBy: " ")
        var nameFirstLettersCaps: String {
            var tempArray: [String] = []
            for string in nameArray {
                tempArray.append(string.capitalized)
            }
            return tempArray.joined(separator: " ")
        }
        if let image = UIImage(named: nameFirstLettersCaps) {
            self.photoImage = image
        }
    }
}

extension Ingredient {
    static func ==(lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name
    }
}

