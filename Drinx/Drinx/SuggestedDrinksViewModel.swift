import Foundation

final class SuggestedDrinksViewModel {
    var tutorialState: TutorialState?
    var suggestedCocktails = [Cocktail]()

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.suggestedDrinksKey)
    }

    init() {
        IngredientController.share.ingredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        CocktailController.shared.getCocktailDictionaryArray { [weak self] in
            self?.suggestedCocktails = CocktailController.getRandomCocktails(numberOfCocktailsToGet: 10)
        }
        let state = ( UserDefaults.standard.object(forKey: TutorialState.suggestedDrinksKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let tutorialState = self.tutorialState else { return }
        UserDefaults.standard.set(tutorialState.isActive, forKey: TutorialState.suggestedDrinksKey)
    }
}

// MARK: - Computed Properties
extension SuggestedDrinksViewModel {
    var cocktails: [Cocktail] {
        return CocktailController.shared.cocktails
    }

    var numberOfSuggestedCocktails: Int {
        self.suggestedCocktails.count
    }
}

// MARK: - Setup utility functions
extension SuggestedDrinksViewModel {
    func findMatches(completion: @escaping () -> Void) {
        var suggestedCocktails = [Cocktail]()
        for cocktail in self.cocktails {
            if Set(cocktail.ingredients).isSubset(of: IngredientController.share.myCabinetIngredientStrings) {
                suggestedCocktails.append(cocktail)
            }
        }
        self.suggestedCocktails = suggestedCocktails
        completion()
    }
}

// MARK: - Navigation Functions
extension SuggestedDrinksViewModel {

}
