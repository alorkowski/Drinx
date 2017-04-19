//
//  IngredientController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/13/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation


class IngredientController {
    
    let ingredientStrings = ["Light rum" , "Applejack" , "Gin" , "Dark rum" , "Sweet Vermouth" , "Strawberry schnapps" , "Scotch" , "Apricot brandy" , "Triple sec" , "Southern Comfort" , "Orange bitters" , "Brandy" , "Lemon vodka" , "Blended whiskey" , "Dry Vermouth" , "Amaretto" , "Tea" , "Creme de Cacao" , "Apple brandy" , "Dubonnet Blanc" , "Apple schnapps" , "Añejo rum" , "Champagne" , "Coffee liqueur" , "Rum" , "Cachaca" , "Sugar" , "Blackberry brandy" , "Calvados" , "Ice" , "Lemon" , "Coffee brandy" , "Bourbon" , "Irish whiskey" , "Vodka" , "Tequila" , "Bitters" , "Lime juice" , "Egg" , "Mint" , "Sherry" , "Cherry brandy" , "Canadian whisky" , "Kahlua" , "Yellow Chartreuse" , "Cognac" , "demerara Sugar" , "Sake" , "Dubonnet Rouge" , "Anis" , "White Creme de Menthe" , "Gold tequila" , "Sweet and sour" , "Salt" , "Galliano" , "Green Creme de Menthe" , "Kummel" , "Anisette" , "Carbonated water" , "Lemon peel" , "White wine" , "Sloe gin" , "Melon liqueur" , "Swedish Punsch" , "Peach brandy" , "Passion fruit juice" , "Peppermint schnapps" , "Creme de Noyaux" , "Grenadine" , "Port" , "Red wine" , "Rye whiskey" , "Grapefruit juice" , "Ricard" , "Banana liqueur" , "Vanilla ice-cream" , "Whiskey" , "Creme de Banane" , "Lime juice cordial" , "Strawberry liqueur" , "Sambuca" , "Peach schnapps" , "Apple juice" , "Berries" , "Blueberries" , "Orange juice" , "Pineapple juice" , "Cranberries" , "Brown sugar" , "Milk" , "Egg yolk" , "Lemon juice" , "Soda water" , "Coconut liqueur" , "Cream" , "Pineapple" , "Sugar syrup" , "Ginger ale" , "Worcestershire sauce" , "Ginger" , "Strawberries" , "Chocolate syrup" , "Yoghurt" , "Grape juice" , "Orange" , "Apple cider" , "Banana" , "Mango" , "Soy milk" , "Lime" , "Cantaloupe" , "Grapes" , "Kiwi" , "Tomato juice" , "Cocoa powder" , "Chocolate" , "Heavy cream" , "Peach Vodka" , "Ouzo" , "Coffee" , "Spiced rum" , "Water" , "Espresso" , "Angelica root" , "Condensed milk" , "Honey" , "Whipping cream" , "Half-and-half" , "Bread" , "Plums" , "Johnnie Walker" , "Vanilla" , "Apple" , "Orange rum" , "Everclear" , "Kool-Aid" , "Lemonade" , "Cranberry juice" , "Eggnog" , "Carbonated soft drink" , "Cloves" , "Raisins" , "Almond" , "Beer" , "Pink lemonade" , "Sherbet" , "Peach nectar" , "Firewater" , "Absolut Citron" , "Malibu rum" , "Midori melon liqueur" , "151 proof rum" , "Bacardi Limon" , "Bailey's irish cream" , "Lager" , "Orange vodka" , "Blue Curacao" , "Absolut Vodka" , "Jägermeister" , "Jack Daniels" , "Drambuie" , "Whisky" , "White rum" , "Pisco" , "Irish cream" , "Yukon Jack" , "Goldschlager" , "Butterscotch schnapps" , "Grand Marnier" , "Peachtree schnapps" , "Absolut Kurant" , "Ale" , "Chambord raspberry liqueur" , "Tia maria" , "Chocolate liqueur" , "Frangelico" , "Barenjager" , "Hpnotiq" , "Coca-Cola" , "Tuaca" , "Tang" , "Tropicana" , "Grain alcohol" , "Schnapps" , "Cider" , "Aftershock" , "Sprite" , "Rumple Minze" , "Key Largo schnapps" , "Pisang Ambon" , "Pernod" , "7-Up" , "Limeade" , "Gold rum" , "Wild Turkey" , "Cointreau" , "Lime vodka" , "Maraschino cherry juice" , "Creme de Cassis" , "Zima" , "Crown Royal" , "Cardamom" , "Orange Curacao" , "Tabasco sauce" , "Peach liqueur" , "Curacao" , "Cherry Heering" , "Fruit punch" , "Vermouth" , "Cherry juice" , "Cinnamon schnapps" , "Orange peel" , "Advocaat" , "Clamato juice" , "Sour mix" , "Apfelkorn" , "Green Chartreuse" , "Root beer schnapps" , "Coconut rum" , "Raspberry schnapps" , "Black Sambuca" , "Vanilla vodka" , "Root beer" , "Absolut Peppar" , "Vanilla schnapps" , "Orange liqueur" , "Kiwi liqueur" , "Hot chocolate" , "Jello" , "Mountain Dew" , "Blueberry schnapps" , "Maui" , "Tennessee whiskey" , "White chocolate liqueur" , "Cream of coconut" , "Citrus vodka" , "Fruit juice" , "Cranberry vodka" , "Campari" , "Corona" , "Chocolate ice-cream" , "Jim Beam" , "Aquavit" , "Hawaiian Punch" , "Blackberry schnapps" , "Chocolate milk" , "Watermelon schnapps" , "Beef bouillon" , "Dr. Pepper" , "Iced tea" , "Hot Damn" , "Club soda" , "Benedictine" , "Dark Creme de Cacao" , "Black rum" , "Cherry Cola" , "Absinthe" , "Angostura bitters" , "Tequila Rose" , "Guinness stout" , "Orange soda" , "Wildberry schnapps" , "Lemon-lime soda" , "Godiva liqueur" , "Baileys irish cream" , "Schweppes Russchian" , "Melon vodka" , "Sour Apple Pucker" , "Raspberry vodka" , "coconut milk"]


    static let share = IngredientController()
    
    var ingredients = [Ingredient]()
    
    var myCabinetIngredientStrings: [String] {
        var strings: [String] = []
        for ingredient in ingredients {
            strings.append(ingredient.name)
        }
        return strings
    }
    
    func add(item: String){
        let ingredient =  Ingredient(name: item)
            ingredients.append(ingredient)
    
    }
    
    func delete(ingredient: Ingredient) {
        for (index, ingredientObj) in ingredients.enumerated() {
            if ingredient.name == ingredientObj.name {
                ingredients.remove(at: index)
            }
        }
    }


}
