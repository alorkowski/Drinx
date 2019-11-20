import UIKit

final class SearchTableViewController: UITableViewController, TutorialDelegate {
    let searchTableViewModel = SearchTableViewModel()
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search"
        self.view.backgroundColor = AppData.backgroundColor
        self.setupNavigationBar()
        self.setupTableView()
        self.setupSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async { self.tableView.reloadData() }
        guard self.searchTableViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.searchDrinksTitle,
                          message: TutorialState.searchDrinksMessage,
                          alertActionTitle: "OK!",
                          completion: self.searchTableViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup functions
extension SearchTableViewController {
    private func setupNavigationBar() {
        self.navigationController?.view.backgroundColor = AppData.backgroundColor
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isOpaque = true
    }

    private func setupSearchController() {
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = self.searchController
        self.definesPresentationContext = true
    }

    private func setupTableView() {
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = .clear
        DrinkTableViewCell.register(with: self.tableView)
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.isFiltering ?
            self.searchTableViewModel.numberOfFilteredCocktails : self.searchTableViewModel.numberOfCocktails
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DrinkTableViewCell.dequeue(from: self.tableView, for: indexPath)
        let cocktail = self.isFiltering ?
            self.searchTableViewModel.filteredCocktails[indexPath.row] : self.searchTableViewModel.cocktails[indexPath.row]
        cell.configure(with: cocktail)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false

        let cocktail = self.isFiltering ?
            self.searchTableViewModel.filteredCocktails[indexPath.row] : self.searchTableViewModel.cocktails[indexPath.row]

        let cocktailDetailTableViewModel = CocktailDetailTableViewModel()
        cocktailDetailTableViewModel.cocktail = cocktail

        let cocktailDetailTableViewController = CocktailDetailTableViewController()
        cocktailDetailTableViewController.cocktailDetailTableViewModel = cocktailDetailTableViewModel
        cocktailDetailTableViewController.title = cocktail.name

        self.navigationController?.pushViewController(cocktailDetailTableViewController, animated: true)
    }
}

// MARK: - UISearchResultsUpdating
extension SearchTableViewController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return self.searchController.searchBar.text?.isEmpty ?? true
    }

    var isFiltering: Bool {
        return self.searchController.isActive && !self.isSearchBarEmpty
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        self.searchTableViewModel.filterContentForSearchText(searchBar.text!) {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
}
