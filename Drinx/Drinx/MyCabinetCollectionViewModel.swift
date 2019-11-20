import UIKit

typealias ResultsViewControllerHandler = (_ resultsViewController: UITableViewController? ) -> Void

final class MyCabinetCollectionViewModel {
    var tutorialState: TutorialState?
    let cabinetController: CabinetController!
    let ingredientController: IngredientController!

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.myCabinetKey)
    }

    init(cabinetController: CabinetController = CabinetController.shared,
         ingredientController: IngredientController = IngredientController.shared) {
        self.cabinetController = cabinetController
        self.ingredientController = ingredientController
        let myIngredients = self.cabinetController.getMyIngredientsFromUserDefaults()
        self.cabinetController.myCabinet.myIngredients = myIngredients.isEmpty ?
            self.cabinetController.myCabinet.sampleIngredients : myIngredients
        self.ingredientController.ingredients = myIngredients.isEmpty ?
            self.cabinetController.myCabinet.sampleIngredients : myIngredients
        self.cabinetController.saveMyCabinetToUserDefaults()
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
            let ingredients = self.ingredientController.ingredientDictionary.keys
            var matchingIngredients: [Ingredient] = []
            for ingredient in ingredients {
                guard ingredient.lowercased().contains(searchTerm) else { continue }
                guard let ingredientArray = self.ingredientController.ingredientDictionary[ingredient] else { return }
                for ingredientName in ingredientArray {
                    let ingredientObject = Ingredient(name: ingredientName)
                    if !self.ingredientController.ingredients.contains(ingredientObject) {
                        matchingIngredients.append(ingredientObject)
                    }
                }
            }
            resultsViewController.resultsArray = matchingIngredients
            self.cabinetController.myCabinet.myIngredients = self.ingredientController.ingredients
            self.cabinetController.saveMyCabinetToUserDefaults()
        }
    }
}
