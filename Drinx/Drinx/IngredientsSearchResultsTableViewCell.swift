import UIKit

final class IngredientsSearchResultsTableViewCell: UITableViewCell, ProgrammaticView {
    let ingredientImageView = UIImageView()
    let ingredientLabelView = UILabel()

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
extension IngredientsSearchResultsTableViewCell {
    private func setupImageView() {
        self.contentView.addSubview(ingredientImageView)
        self.ingredientImageView.contentMode = .scaleAspectFit
        self.ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.ingredientImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.ingredientImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.ingredientImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupLabelView() {
        self.contentView.addSubview(ingredientLabelView)
        self.ingredientLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientLabelView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.ingredientLabelView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.ingredientLabelView.leadingAnchor.constraint(equalTo: self.ingredientImageView.trailingAnchor).isActive = true
        self.ingredientLabelView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Utility Functions
extension IngredientsSearchResultsTableViewCell {
    func configure(with ingredient: Ingredient?) {
        defer { self.reloadInputViews() }
        guard let ingredient = ingredient else { return }
        self.ingredientLabelView.text = ingredient.name.trimmingCharacters(in: .whitespacesAndNewlines)
        DispatchQueue.main.async { self.ingredientImageView.image = ingredient.photoImage }
    }
}
