import Foundation

final class CabinetController {
    let ingredientIDsKey = "ingredientIDs"
    
    static let shared = CabinetController()
    var myCabinet = Cabinet()
    var cabinetHasBeenUpdated: Bool = false
    
    func saveMyCabinetToUserDefaults() {
        UserDefaults.standard.set(myCabinet.ingredientIDs, forKey: ingredientIDsKey)
    }

    func getMyIngredientsFromUserDefaults() -> [Ingredient] {
        var ingredients: [Ingredient] = []
        guard let myIngredientsStringArray = UserDefaults.standard.array(forKey: ingredientIDsKey) as? [String] else { return [] }
        for name in myIngredientsStringArray {
            let ingredient = Ingredient(name: name)
            ingredients.append(ingredient)
        }
        return ingredients
    }
}
