import UIKit

final class CocktailDetailImageTableViewCell: UITableViewCell, ProgrammaticView {
    var drinkImageView = UIImageView()

    var cocktail: Cocktail? {
        didSet {
            updateCell()
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup functions
extension CocktailDetailImageTableViewCell {
    private func setupImageView() {
        self.contentView.addSubview(drinkImageView)
        self.drinkImageView.contentMode = .scaleAspectFit
        self.drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.drinkImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.drinkImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.drinkImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.drinkImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Utility functions
extension CocktailDetailImageTableViewCell {
    private func updateCell() {
        guard let cocktail = cocktail else { return }
        if let image = cocktail.image {
            self.drinkImageView.image = image
        } else {
            if let image = UIImage(named: cocktail.ingredients[0]) {
                self.drinkImageView.image = image
            } else if let image = UIImage(named: cocktail.ingredients[1]) {
                self.drinkImageView.image = image
            }
        }
    }
}
