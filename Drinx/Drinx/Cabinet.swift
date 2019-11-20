import Foundation

final class Cabinet {
    static let sampleIngredientStrings = ["Gin" ,
                                          "Scotch" ,
                                          "Triple sec" ,
                                          "Brandy" ,
                                          "Coffee liqueur" ,
                                          "Rum" ,
                                          "Sugar" ,
                                          "Ice" ,
                                          "Lemon" ,
                                          "Bourbon" ,
                                          "Vodka" ,
                                          "Tequila" ,
                                          "Lime juice" ,
                                          "Egg" ,
                                          "Salt" ,
                                          "Carbonated water" ,
                                          "Lemon peel" ,
                                          "Apple juice" ,
                                          "Orange juice" ,
                                          "Brown sugar" ,
                                          "Milk" ,
                                          "Egg yolk" ,
                                          "Lemon juice" ,
                                          "Soda water" ,
                                          "Whisky" ,
                                          "Coca-Cola"]
    
    var sampleIngredients: [Ingredient] {
        var ingredients: [Ingredient] = []
        for ingredientString in Cabinet.sampleIngredientStrings {
            ingredients.append(Ingredient(name: ingredientString))
        }
        return ingredients
    }
    
    var myIngredients: [Ingredient] = []

    var ingredientIDs: [String] {
        var ingredientList: [String] = []
        for ingredient in myIngredients {
            ingredientList.append(ingredient.name)
        }
        return ingredientList
    }
}
