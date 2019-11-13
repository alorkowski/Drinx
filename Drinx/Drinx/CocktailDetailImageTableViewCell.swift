import UIKit

final class CocktailDetailImageTableViewCell: UITableViewCell, ProgrammaticView {
    var imageCell = UIImageView()

    var cocktail: Cocktail? {
        didSet {
            updateCell()
        }
    }
}

extension CocktailDetailImageTableViewCell {
    func updateCell() {
//        guard let cocktail = cocktail else { return }
//        if let image = cocktail.image {
//            self.imageCell?.image = image
//        } else {
//            if let image = UIImage(named: cocktail.ingredients[0]) {
//                self.imageCell?.image = image
//            } else if let image = UIImage(named: cocktail.ingredients[1]) {
//                self.imageCell?.image = image
//            }
//        }
    }
}
