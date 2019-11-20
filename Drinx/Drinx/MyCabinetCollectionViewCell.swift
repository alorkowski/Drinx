import UIKit

final class MyCabinetCollectionViewCell: UICollectionViewCell, ProgrammaticView {
    let ingredientImageView: UIImageView = UIImageView()
    let ingredientLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupImageView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup functions
extension MyCabinetCollectionViewCell {
    private func setupImageView() {
        self.contentView.addSubview(ingredientImageView)
        self.ingredientImageView.contentMode = .scaleAspectFit
        self.ingredientImageView.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.ingredientImageView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.ingredientImageView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.ingredientImageView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

    private func setupLabelView() {
        self.contentView.addSubview(ingredientLabel)
        self.ingredientLabel.translatesAutoresizingMaskIntoConstraints = false
        self.ingredientLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor).isActive = true
        self.ingredientLabel.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.ingredientLabel.leadingAnchor.constraint(equalTo: self.ingredientImageView.trailingAnchor).isActive = true
        self.ingredientLabel.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

// MARK: - Utility Functions
extension MyCabinetCollectionViewCell {
    func configure(with ingredient: Ingredient?) {
        guard let ingredient = ingredient else { return }
        self.ingredientImageView.image = ingredient.photoImage
        self.ingredientLabel.text = ingredient.name
    }
}
