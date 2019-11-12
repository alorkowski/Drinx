import UIKit

final class CockailDetailImageTableViewCell: UITableViewCell {
    @IBOutlet weak var imageCell: UIImageView!

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
