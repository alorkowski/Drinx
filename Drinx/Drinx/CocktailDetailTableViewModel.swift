import Foundation

class CocktailDetailTableViewModel {
    var tutorialState: TutorialState?
    var cocktail: Cocktail?
    let mockCocktail = ["idDrink":"15112","strDrink":"Alamo Splash","strCategory":"Ordinary Drink","strAlcoholic":"Alcoholic","strGlass":"Collins glass","strInstructions":"Mix with cracked ice and strain into collins glass.","strDrinkThumb":"","strIngredient1":"Tequila","strIngredient2":"Orange juice","strIngredient3":"Pineapple juice","strIngredient4":"Lemon-lime soda","strIngredient5":"","strIngredient6":"","strIngredient7":"","strIngredient8":"","strIngredient9":"","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strMeasure1":"1 1/2 oz ","strMeasure2":"1 oz ","strMeasure3":"1/2 oz ","strMeasure4":"1 splash ","strMeasure5":" ","strMeasure6":" ","strMeasure7":" ","strMeasure8":" ","strMeasure9":" ","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","dateModified":""]

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.cocktailDetailKey)
    }

    init() {
        let state = ( UserDefaults.standard.object(forKey: TutorialState.cocktailDetailKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.cocktailDetailKey)
    }
}

extension CocktailDetailTableViewModel {
    func saveCocktailToFavorites() {
        guard let cocktail = self.cocktail,
            !CocktailController.shared.savedCocktails.contains(cocktail)
            else { return }
        CocktailController.shared.savedCocktails.append(cocktail)
        CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
    }
}
