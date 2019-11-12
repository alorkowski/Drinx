import UIKit

final class MyCabinetCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!
    
    var ingredient: Ingredient? {
        didSet {
            self.updateViews()
        }
    }
    
    func updateViews() {
        if let ingredient = ingredient {
            self.ingredientImageView.image = ingredient.photoImage
            self.ingredientLabel.text = ingredient.name
        }
    }
}
