import UIKit

final class SearchTableViewCell: UITableViewCell, ProgrammaticView {
    let drinkImageView = UIImageView()
    let drinkNameText = UILabel()

    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }
}

extension SearchTableViewCell {
    func update(cocktail: Cocktail) {
        drinkNameText.text = cocktail.name
//        if cocktail.image != nil {
//            drinkImageView.image = cocktail.image
//        } else {
//            if let image = UIImage(named: cocktail.ingredients[0]) {
//                drinkImageView.image = image
//            } else if let image = UIImage(named: cocktail.ingredients[1]) {
//                drinkImageView.image = image
//            }
//        }
    }
}
