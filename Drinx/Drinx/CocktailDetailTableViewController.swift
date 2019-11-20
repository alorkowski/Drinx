import UIKit

final class CocktailDetailTableViewController: UITableViewController, TutorialDelegate {
    var cocktailDetailTableViewModel: CocktailDetailTableViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBar()
        self.setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.title = self.cocktailDetailTableViewModel.cocktail?.name
        guard self.cocktailDetailTableViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.cocktailDetailTitle,
                          message: TutorialState.cocktailDetailMessage,
                          alertActionTitle: "OK!",
                          completion: self.cocktailDetailTableViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup functions
extension CocktailDetailTableViewController {
    private func setNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back",
                                                                style: .done,
                                                                target: self,
                                                                action: #selector(done))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                                 target: self, action: #selector(saveCocktailToFavorites))
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.allowsSelection = false
        CocktailDetailImageTableViewCell.register(with: self.tableView)
        CocktailDetailIngredientTableViewCell.register(with: self.tableView)
        CocktailDetailInstructionTableViewCell.register(with: self.tableView)
    }

    @objc func saveCocktailToFavorites() {
        self.cocktailDetailTableViewModel.saveCocktailToFavorites()
        self.resignFirstResponder()
        self.navigationController?.popViewController(animated: true)
    }

    @objc func done() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension CocktailDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let cocktail = self.cocktailDetailTableViewModel.cocktail else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return cocktail.ingredients.count
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.view.frame.size.width + 44
        case 1:
            return 30
        case 2:
            return 200
        default:
            return 30
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.view.frame.size.width + 44
        case 1:
            return 30
        case 2:
            return UITableView.automaticDimension
        default:
            return 30
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = CocktailDetailImageTableViewCell.dequeue(from: tableView, for: indexPath)
            cell.cocktail = self.cocktailDetailTableViewModel.cocktail
            return cell
        case 1:
            let cell = CocktailDetailIngredientTableViewCell.dequeue(from: tableView, for: indexPath)
            cell.cocktail = self.cocktailDetailTableViewModel.cocktail
            if let ingredient = self.cocktailDetailTableViewModel.cocktail?.ingredients[indexPath.row],
                let amount = self.cocktailDetailTableViewModel.cocktail?.ingredientProportions[indexPath.row] {
                cell.textLabel?.text = "\(ingredient) - \(amount)"
            }
            return cell
        case 2:
            let cell = CocktailDetailInstructionTableViewCell.dequeue(from: tableView, for: indexPath)
            cell.cocktail = self.cocktailDetailTableViewModel.cocktail
            if let instructions = self.cocktailDetailTableViewModel.cocktail?.instructions { cell.textLabel?.text = instructions }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            return cell
        default:
            return UITableViewCell()
        }
    }
}
