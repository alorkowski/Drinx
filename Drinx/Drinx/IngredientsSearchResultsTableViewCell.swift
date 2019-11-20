import UIKit

final class IngredientsSearchResultsTableViewCell: UITableViewCell {
    @IBOutlet weak var imageLabel: UIImageView!
    @IBOutlet weak var ingredientLabel: UILabel!

    var ingredient: Ingredient? {
        didSet {
            updateViews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateViews()
    }

    func updateViews() {
        if let ingredient = ingredient {
            self.ingredientLabel.text = ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines)
            DispatchQueue.main.async {
                self.imageLabel.image = ingredient.photoImage
            }
        }
        reloadInputViews()
    }
}
