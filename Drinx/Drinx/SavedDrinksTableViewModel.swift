import Foundation

final class SavedDrinksTableViewModel {
    var tutorialState: TutorialState?

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.favoriteDrinksKey)
    }

    init() {
        CocktailController.shared.fetchMyFavoriteCocktailsFromUserDefaults()
        if CocktailController.shared.savedCocktails.isEmpty {
            CocktailController.shared.savedCocktails = CocktailController.shared.sampleSavedCocktails
        }
        let state = ( UserDefaults.standard.object(forKey: TutorialState.favoriteDrinksKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.favoriteDrinksKey)
    }
}
