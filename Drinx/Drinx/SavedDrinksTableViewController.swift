import UIKit

final class SavedDrinksTableViewController: UITableViewController {
    var showTutorial = true

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        CocktailController.shared.fetchMyFavoriteCocktailsFromUserDefaults()
        if CocktailController.shared.savedCocktails.isEmpty {
            CocktailController.shared.savedCocktails = CocktailController.shared.sampleSavedCocktails
        }
        self.showTutorial = ( UserDefaults.standard.object(forKey: "showTutorialSaved") as? Bool ) ?? true
        UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSaved")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 44, right: 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.showTutorial {
//            TutorialController.shared.drinksTutorial(viewController: self,
//                                                     title: TutorialController.shared.favoriteDrinksTitle,
//                                                     message: TutorialController.shared.favoriteDrinksMessage,
//                                                     alertActionTitle: "OK!") {
//                self.showTutorial = false
//                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSaved")
//            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedDrinkCell",
                                                 for: indexPath) as! SavedDrinksTableViewCell
        cell.cocktail = CocktailController.shared.savedCocktails[indexPath.row]
        return cell
    }
}

// MARK: UITableViewDelegate
extension SavedDrinksTableViewController {
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        CocktailController.shared.savedCocktails.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        self.tableView.reloadData()
        CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
    }
}

// MARK: - Navigation
extension SavedDrinksTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dvc = segue.destination as? CocktailDetailTableViewController
            else { return }
        if let transitionStyle = UIModalTransitionStyle(rawValue: 2) {
            dvc.modalTransitionStyle = transitionStyle
        }
        dvc.cocktail = CocktailController.shared.savedCocktails[indexPath.row]
    }
}
