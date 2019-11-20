import UIKit

final class SavedDrinksTableViewController: UITableViewController, TutorialDelegate {
    let savedDrinksTableViewModel = SavedDrinksTableViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Saved"
        self.view.backgroundColor = AppFeatures.backgroundColor
        self.setupNavigationBar()
        self.setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.savedDrinksTableViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.favoriteDrinksTitle,
                          message: TutorialState.favoriteDrinksMessage,
                          alertActionTitle: "OK!",
                          completion: self.savedDrinksTableViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup Functions
extension SavedDrinksTableViewController {
    private func setupNavigationBar() {
        self.navigationController?.view.backgroundColor = AppFeatures.backgroundColor
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isOpaque = true
    }

    private func setupTableView() {
        self.tableView.backgroundColor = .clear
        DrinkTableViewCell.register(with: self.tableView)
    }
}

// MARK: - UITableViewDataSource
extension SavedDrinksTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return CocktailController.shared.savedCocktails.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DrinkTableViewCell.dequeue(from: self.tableView, for: indexPath)
        let cocktail = CocktailController.shared.savedCocktails[indexPath.row]
        cell.configure(with: cocktail)
        return cell
    }
}

// MARK: UITableViewDelegate
extension SavedDrinksTableViewController {
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        CocktailController.shared.savedCocktails.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.reloadData()
        CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let cocktailDetailTableViewModel = CocktailDetailTableViewModel()
        cocktailDetailTableViewModel.cocktail = CocktailController.shared.savedCocktails[indexPath.row]

        let cocktailDetailTableViewController = CocktailDetailTableViewController()
        cocktailDetailTableViewController.cocktailDetailTableViewModel = cocktailDetailTableViewModel
        cocktailDetailTableViewController.title = CocktailController.shared.savedCocktails[indexPath.row].name

        self.navigationController?.pushViewController(cocktailDetailTableViewController, animated: true)
    }
}
