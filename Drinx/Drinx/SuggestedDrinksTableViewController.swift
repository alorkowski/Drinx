import UIKit

class SuggestedDrinksTableViewController: UITableViewController {
    let cocktail = [String]()
    var showTutorial = true
    var cocktailDictionaries = [[String: Any]]()
    var suggestedCocktails = [Cocktail]()
    var tempCocktails = [Cocktail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        IngredientController.share.ingredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        tableView.separatorStyle = .none
        self.getCocktailDictionaryArray()
        if self.suggestedCocktails.count == 0 {
            self.suggestedCocktails = CocktailController.getRandomCocktails(numberOfCocktailsToGet: 10)
        }
        self.showTutorial = ( UserDefaults.standard.object(forKey: "showTutorialSuggested") as? Bool ) ?? true
        UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSuggested")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 45, right: 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        guard CabinetController.shared.cabinetHasBeenUpdated else { return }
        findMatches { [weak self] in
            CabinetController.shared.cabinetHasBeenUpdated = false
            self?.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        guard showTutorial else { return }
        TutorialController.shared.drinksTutorial(viewController: self,
                                                 title: TutorialController.shared.suggestedDrinksTitle,
                                                 message: TutorialController.shared.suggestedDrinksMessage,
                                                 alertActionTitle: "OK!") { [weak self] in
            self?.showTutorial = false
            UserDefaults.standard.set(self?.showTutorial, forKey: "showTutorialSuggested")
        }
    }
}

// MARK: - Setup utility functions
extension SuggestedDrinksTableViewController {
    private func getCocktailDictionaryArray() {
        CocktailController.shared.getCocktailDictionaryArray { [weak self] in
            self?.findMatches { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    private func findMatches(completion: @escaping () -> Void) {
        var sugCocktails = [Cocktail]()
        for cocktail in cocktails {
            let cocktailIngredients = Set(cocktail.ingredients)
            if cocktailIngredients.isSubset(of: IngredientController.share.myCabinetIngredientStrings) {
                sugCocktails.append(cocktail)
            }
        }
        self.suggestedCocktails = sugCocktails
        self.tableView.reloadData()
    }
}

// MARK: - Computed Properties
extension SuggestedDrinksTableViewController {
    var cocktails: [Cocktail] {
        return CocktailController.shared.cocktails
    }
}

// MARK: - UITableViewDataSource
extension SuggestedDrinksTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return self.suggestedCocktails.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as! SuggestedTableViewCell
        let cocktail = suggestedCocktails[indexPath.row]
        cell.update(cocktail: cocktail)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SuggestedDrinksTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }
}

// MARK: - Navigation
extension SuggestedDrinksTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let dvc = segue.destination as? CocktailDetailTableViewController else { return }
        if let transitionStyle = UIModalTransitionStyle(rawValue: 2) {
            dvc.modalTransitionStyle = transitionStyle
        }
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let cocktail = suggestedCocktails[indexPath.row]
        dvc.cocktail = cocktail
    }
}
