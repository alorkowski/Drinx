import Foundation

final class SavedDrinksTableViewModel {
    var tutorialState: TutorialState?
    let cocktailController: CocktailController!

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.favoriteDrinksKey)
    }

    init(cocktailController: CocktailController = CocktailController.shared) {
        self.cocktailController = cocktailController
        self.cocktailController.fetchMyFavoriteCocktailsFromUserDefaults()
        if self.cocktailController.savedCocktails.isEmpty {
            self.cocktailController.savedCocktails = self.cocktailController.sampleSavedCocktails
        }
        let state = ( UserDefaults.standard.object(forKey: TutorialState.favoriteDrinksKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.favoriteDrinksKey)
    }
}
