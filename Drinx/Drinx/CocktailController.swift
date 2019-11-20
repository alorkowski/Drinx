import Foundation

class CocktailController {
    private let savedCocktailsKey = "savedCocktails"
    static let shared = CocktailController()
    var cocktails: [Cocktail] = []
    var savedCocktails: [Cocktail] = []
    var suggestedCocktails: [Cocktail] = []

    var sampleSavedCocktails: [Cocktail] {
        return CocktailController.getRandomCocktails(numberOfCocktailsToGet: 2)
    }

    var mockIngredients: [String] = ["Vodka", "Ice", "Orange juice", "Gin", "Schnapps" , "Cider" , "Aftershock" , "Sprite" , "Rumple Minze", "Peach Vodka" , "Ouzo" , "Coffee" , "Spiced rum" , "Water" , "Espresso" , "Angelica root" , "Condensed milk" , "Honey" , "Whipping cream"]

    // MARK: - UserDefaults
    func saveMyFavoriteCocktailsToUserDefaults() {
        var cocktailIDStrings: [String] = []
        for cocktail in self.savedCocktails {
            guard let idString = cocktail.apiID else { break }
            cocktailIDStrings.append(idString)
        }
        UserDefaults.standard.set(cocktailIDStrings, forKey: savedCocktailsKey)
    }

    func fetchMyFavoriteCocktailsFromUserDefaults() {
        guard let cocktailIDStrings = UserDefaults.standard.value(forKey: savedCocktailsKey) as? [String] else { return }
        guard let cocktailDictionaries = JSONController.shared.getCocktailDictionaryArray() else { return }
        var cocktails: [Cocktail] = []
        for id in cocktailIDStrings {
            for cocktail in cocktailDictionaries {
                guard let drinkID = cocktail["idDrink"] as? String else { break }
                if drinkID == id {
                    guard let ct = Cocktail(cocktailDictionary: cocktail) else { break }
                    cocktails.append(ct)
                }
            }
        }
        self.savedCocktails = cocktails
    }

    func getCocktailDictionaryArray(completion: () -> Void) {
        guard let path = Bundle.main.path(forResource: "CocktailRecipes", ofType: "json") else { return }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return }
            let cocktailsArray = jsonArray.compactMap( { Cocktail(cocktailDictionary: $0)} )
            self.cocktails = cocktailsArray
            completion()
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }

    func searchCocktails(for searchTerm: String,
                         perRecordCompletion: @escaping (Cocktail) -> Void,
                         completion: (() -> Void)) {
        for cocktail in self.cocktails {
            let lowercasedCocktailIngredients = cocktail.ingredients.joined(separator: " ")
            if cocktail.name.lowercased().contains(searchTerm.lowercased()) {
                DispatchQueue.main.async {
                    perRecordCompletion(cocktail)
                }
            } else if lowercasedCocktailIngredients.contains(searchTerm.lowercased()) {
                DispatchQueue.main.async {
                    perRecordCompletion(cocktail)
                }
            }
        }
        completion()
    }
}

extension CocktailController {
    static func getRandomCocktails(numberOfCocktailsToGet: Int) -> [Cocktail] {
        var randomCocktails: [Cocktail] = []
        for _ in 1...numberOfCocktailsToGet {
            let randomNumber = Int(arc4random_uniform(UInt32(CocktailController.shared.cocktails.count)))
            let cocktail = CocktailController.shared.cocktails[randomNumber]
            randomCocktails.append(cocktail)
        }
        return randomCocktails
    }
}
