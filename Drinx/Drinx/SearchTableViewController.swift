import UIKit

final class SearchTableViewController: UITableViewController, TutorialDelegate {
    let searchTableViewModel = SearchTableViewModel()
    var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        SearchTableViewCell.register(with: self.tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
        guard self.searchTableViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.searchDrinksTitle,
                          message: TutorialState.searchDrinksMessage,
                          alertActionTitle: "OK!",
                          completion: self.searchTableViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.searchTableViewModel.numberOfCocktails
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SearchTableViewCell.dequeue(from: self.tableView, for: indexPath)
        let cocktail = self.searchTableViewModel.cocktails[indexPath.row]
        cell.update(cocktail: cocktail)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text else { return }
        guard searchTerm.count >= 3 else { return }
        var cocktails = [Cocktail]()
        self.tableView.reloadData()
        CocktailController.shared.searchCocktails(for: searchTerm, perRecordCompletion: { [weak self] cocktail in
            if !(self?.searchTableViewModel.cocktails.contains(cocktail) ?? false) {
                cocktails.append(cocktail)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }){}
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else { return }
        guard searchTerm != "" else {
            self.searchTableViewModel.cocktails = CocktailController.shared.cocktails
            self.tableView.reloadData()
            return
        }

        let perRecordCompletion: (Cocktail) -> Void = { [weak self] cocktail in
            guard !(self?.searchTableViewModel.cocktails.contains(cocktail) ?? false) else { return }
            self?.searchTableViewModel.cocktails.append(cocktail)
            self?.tableView.reloadData()
        }

        self.searchTableViewModel.cocktails = []
        CocktailController.shared.searchCocktails(for: searchTerm,
                                                  perRecordCompletion: perRecordCompletion,
                                                  completion: {})
    }
}
