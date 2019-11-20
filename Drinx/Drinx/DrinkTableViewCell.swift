import UIKit

class DrinkTableViewCell: UITableViewCell, ProgrammaticView {
    let drinkImageView = UIImageView()
    let drinkLabelView = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupImageView()
        self.setupLabelView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup functions
extension DrinkTableViewCell {
    private func setupImageView() {
        self.contentView.addSubview(drinkImageView)
        self.drinkImageView.contentMode = .scaleAspectFit
        self.drinkImageView.translatesAutoresizingMaskIntoConstraints = false
        self.drinkImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.drinkImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.drinkImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.drinkImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupLabelView() {
        self.contentView.addSubview(drinkLabelView)
        self.drinkLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.drinkLabelView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.drinkLabelView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.drinkLabelView.leadingAnchor.constraint(equalTo: self.drinkImageView.trailingAnchor).isActive = true
        self.drinkLabelView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Utility Functions
extension DrinkTableViewCell {
    func configure(with cocktail: Cocktail) {
        drinkImageView.image = cocktail.image ?? UIImage(named: cocktail.ingredients[0])
        drinkLabelView.text = cocktail.name
    }
}
