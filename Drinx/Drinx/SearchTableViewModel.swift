import Foundation

final class SearchTableViewModel {
    var tutorialState: TutorialState?
    var cocktails = CocktailController.shared.cocktails
    var filteredCocktails = [Cocktail]()

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.searchDrinksKey)
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

    var numberOfFilteredCocktails: Int {
        self.filteredCocktails.count
    }
}

// MARK: - SearchController utility functions
extension SearchTableViewModel {
    func filterContentForSearchText(_ searchText: String, completion: () -> Void) {
        self.filteredCocktails = cocktails.filter { (cocktail: Cocktail) -> Bool in
            return cocktail.name.lowercased().contains(searchText.lowercased())
        }
        completion()
    }
}
