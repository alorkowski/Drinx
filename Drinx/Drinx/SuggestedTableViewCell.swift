import UIKit

class SuggestedTableViewCell: UITableViewCell, ProgrammaticView {
    let drinkImageView = UIImageView()
    let drinkLabelView = UILabel()

    var cocktail: Cocktail? {
        didSet {
            guard let cocktail = cocktail else { return }
            update(cocktail: cocktail)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupLabelView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup functions
extension SuggestedTableViewCell {
    private func setupLabelView() {
        self.contentView.addSubview(drinkLabelView)
        self.drinkLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.drinkLabelView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.drinkLabelView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.drinkLabelView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.drinkLabelView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Utility Functions
extension SuggestedTableViewCell {
    func update(cocktail: Cocktail) {
//        if let image = cocktail.image {
//            drinkImageView.image = image
//        } else {
//            drinkImageView.image = UIImage(named: cocktail.ingredients[0])
//        }
        drinkLabelView.text = cocktail.name
    }
}
