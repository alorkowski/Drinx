import Foundation

final class SearchTableViewModel {
    var tutorialState: TutorialState?
    var filterCocktail = [Cocktail]()
    var cocktails = CocktailController.shared.cocktails

//    var cocktails = [Cocktail]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.suggestedDrinksKey)
    }
    
    init() {
        let state = ( UserDefaults.standard.object(forKey: TutorialState.searchDrinksKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.searchDrinksKey)
    }
}

// MARK: - Computed Properties
extension SearchTableViewModel {
    var numberOfCocktails: Int {
        self.cocktails.count
    }
}
