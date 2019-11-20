import UIKit

typealias ResultsViewControllerHandler = (_ resultsViewController: UITableViewController? ) -> Void

final class MyCabinetCollectionViewModel {
    var tutorialState: TutorialState?

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.myCabinetKey)
    }

    init() {
        let myIngredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        CabinetController.shared.myCabinet.myIngredients = myIngredients.isEmpty ?
            CabinetController.shared.myCabinet.sampleIngredients : myIngredients
        IngredientController.shared.ingredients = myIngredients.isEmpty ?
            CabinetController.shared.myCabinet.sampleIngredients : myIngredients
        CabinetController.shared.saveMyCabinetToUserDefaults()
        let state = ( UserDefaults.standard.object(forKey: TutorialState.myCabinetKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.myCabinetKey)
    }
}

// MARK: - UISearchResultsUpdating
extension MyCabinetCollectionViewModel {
    func filterContentFor(_ searchController: UISearchController, completion: @escaping ResultsViewControllerHandler) {
        defer { completion(searchController.searchResultsController as? IngredientSearchResultsTVC) }
        guard let resultsViewController = searchController.searchResultsController as? IngredientSearchResultsTVC,
            let searchTerm = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            else { return }
        DispatchQueue.global().async {
            let ingredients = IngredientController.shared.ingredientDictionary.keys
            var matchingIngredients: [Ingredient] = []
            for ingredient in ingredients {
                guard ingredient.lowercased().contains(searchTerm) else { continue }
                guard let ingredientArray = IngredientController.shared.ingredientDictionary[ingredient] else { return }
                for ingredientName in ingredientArray {
                    let ingredientObject = Ingredient(name: ingredientName)
                    if !IngredientController.shared.ingredients.contains(ingredientObject) {
                        matchingIngredients.append(ingredientObject)
                    }
                }
            }
            resultsViewController.resultsArray = matchingIngredients
            CabinetController.shared.myCabinet.myIngredients = IngredientController.shared.ingredients
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
    }
}
