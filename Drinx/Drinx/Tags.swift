//
//  Tags.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/24/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import Foundation

class Tags {
    
    let ingredientDictionaries = ["151 proof rum" : ["151 proof rum"],
                             "7-Up" : ["7-Up"],
                             "Absinthe" : ["Absinthe"],
                             "Absolut Citron" : ["Absolut Citron"],
                             "Absolut Kurant" : ["Absolut Kurant"],
                             "Absolut Peppar" : ["Absolut Peppar"],
                             "Absolut Vodka" : ["Absolut Vodka"],
                             "Advocaat" : ["Advocaat"],
                             "Aftershock" : ["Aftershock"],
                             "Ale" : ["Ale"],
                             "Almond" : ["Almond"],
                             "Almond liqueur" : ["Amaretto"],
                             "Amaretto" : ["Amaretto"],
                             "Angelica root" : ["Angelica root"],
                             "Angostura bitters" : ["Angostura bitters"],
                             "Anis" : ["Anis"],
                             "Anisette" : ["Anisette"],
                             "Añejo rum" : ["Añejo rum"],
                             "Apfelkorn" : ["Apfelkorn"],
                             "Apple" : ["Apple"],
                             "Apple brandy" : ["Apple brandy"],
                             "Apple cider" : ["Apple cider"],
                             "Apple juice" : ["Apple juice"],
                             "Apple schnapps" : ["Apple schnapps"],
                             "Applejack" : ["Applejack"],
                             "Apricot brandy" : ["Apricot brandy"],
                             "Aquavit" : ["Aquavit"],
                             "Bacardi" : ["151 proof rum", "Rum"],
                             "Bacardi 151" : ["151 proof rum"],
                             "Bacardi Limon" : ["Bacardi Limon"],
                             "Bailey's irish cream" : ["Bailey\'s irish cream"],
                             "Baileys irish cream" : ["Baileys irish cream"],
                             "Banana" : ["Banana"],
                             "Banana liqueur" : ["Banana liqueur"],
                             "Barenjager" : ["Barenjager"],
                             "Beef bouillon" : ["Beef bouillon"],
                             "Beer" : ["Beer"],
                             "Benedictine" : ["Benedictine"],
                             "Berries" : ["Berries"],
                             "Bitters" : ["Bitters"],
                             "Black rum" : ["Black rum"],
                             "Black Sambuca" : ["Black Sambuca"],
                             "Blackberry brandy" : ["Blackberry brandy"],
                             "Blackberry schnapps" : ["Blackberry schnapps"],
                             "Blended whiskey" : ["Blended whiskey"],
                             "Blue Curacao" : ["Blue Curacao"],
                             "Blueberries" : ["Blueberries"],
                             "Blueberry schnapps" : ["Blueberry schnapps"],
                             "Bourbon" : ["Bourbon"],
                             "Brandy" : ["Brandy"],
                             "Bread" : ["Bread"],
                             "Brown sugar" : ["Brown sugar"],
                             "Butterscotch schnapps" : ["Butterscotch schnapps"],
                             "Cachaca" : ["Cachaca"],
                             "Calvados" : ["Calvados"],
                             "Campari" : ["Campari"],
                             "Canadian whisky" : ["Canadian whisky"],
                             "Cantaloupe" : ["Cantaloupe"],
                             "Carbonated soft drink" : ["Carbonated soft drink"],
                             "Carbonated water" : ["Carbonated water"],
                             "Cardamom" : ["Cardamom"],
                             "Chambord raspberry liqueur" : ["Chambord raspberry liqueur"],
                             "Champagne" : ["Champagne"],
                             "Cherry brandy" : ["Cherry brandy"],
                             "Cherry Cola" : ["Cherry Cola"],
                             "Cherry Heering" : ["Cherry Heering"],
                             "Cherry juice" : ["Cherry juice"],
                             "Chocolate" : ["Chocolate"],
                             "Chocolate ice-cream" : ["Chocolate ice-cream"],
                             "Chocolate liqueur" : ["Chocolate liqueur"],
                             "Chocolate milk" : ["Chocolate milk"],
                             "Chocolate syrup" : ["Chocolate syrup"],
                             "Cider" : ["Cider"],
                             "Cinnamon schnapps" : ["Cinnamon schnapps"],
                             "Citrus vodka" : ["Citrus vodka"],
                             "Clamato juice" : ["Clamato juice"],
                             "Cloves" : ["Cloves"],
                             "Club soda" : ["Soda water" , "Club soda"],
                             "Coca-Cola" : ["Coca-Cola"],
                             "Cocoa powder" : ["Cocoa powder"],
                             "Coconut liqueur" : ["Coconut liqueur"],
                             "coconut milk" : ["coconut milk"],
                             "Coconut rum" : ["Coconut rum"],
                             "Coffee" : ["Coffee"],
                             "Coffee brandy" : ["Coffee brandy"],
                             "Coffee liqueur" : ["Coffee liqueur", "Kahlua"],
                             "Cognac" : ["Cognac"],
                             "Cointreau" : ["Cointreau"],
                             "Coke" : ["Coca-Cola"],
                             "Condensed milk" : ["Condensed milk"],
                             "Corona" : ["Corona"],
                             "Cranberries" : ["Cranberries"],
                             "Cranberry juice" : ["Cranberry juice"],
                             "Cranberry vodka" : ["Cranberry vodka"],
                             "Cream" : ["Cream"],
                             "Cream of coconut" : ["Cream of coconut"],
                             "Creme de Banane" : ["Creme de Banane"],
                             "Creme de Cacao" : ["Creme de Cacao"],
                             "Creme de Cassis" : ["Creme de Cassis"],
                             "Creme de Noyaux" : ["Creme de Noyaux"],
                             "Crown Royal" : ["Crown Royal"],
                             "Curacao" : ["Curacao"],
                             "Dark Creme de Cacao" : ["Dark Creme de Cacao"],
                             "Dark rum" : ["Dark rum"],
                             "demerara Sugar" : ["demerara Sugar"],
                             "Disaronno" : ["Amaretto"],
                             "Dr. Pepper" : ["Dr. Pepper"],
                             "Drambuie" : ["Drambuie"],
                             "Dry Vermouth" : ["Dry Vermouth"],
                             "Dubonnet Blanc" : ["Dubonnet Blanc"],
                             "Dubonnet Rouge" : ["Dubonnet Rouge"],
                             "Egg" : ["Egg"],
                             "Egg yolk" : ["Egg yolk"],
                             "Eggnog" : ["Eggnog"],
                             "Espresso" : ["Espresso"],
                             "Everclear" : ["Everclear"],
                             "Firewater" : ["Firewater"],
                             "Frangelico" : ["Frangelico"],
                             "Fruit juice" : ["Fruit juice"],
                             "Fruit punch" : ["Fruit punch"],
                             "Galliano" : ["Galliano"],
                             "Gin" : ["Gin"],
                             "Ginger" : ["Ginger"],
                             "Ginger ale" : ["Ginger ale"],
                             "Godiva liqueur" : ["Godiva liqueur"],
                             "Gold rum" : ["Gold rum"],
                             "Gold tequila" : ["Gold tequila"],
                             "Goldschlager" : ["Goldschlager"],
                             "Grain alcohol" : ["Grain alcohol"],
                             "Grand Marnier" : ["Grand Marnier"],
                             "Grape juice" : ["Grape juice"],
                             "Grapefruit juice" : ["Grapefruit juice"],
                             "Grapes" : ["Grapes"],
                             "Green Chartreuse" : ["Green Chartreuse"],
                             "Green Creme de Menthe" : ["Green Creme de Menthe"],
                             "Grenadine" : ["Grenadine"],
                             "Guinness stout" : ["Guinness stout"],
                             "Half-and-half" : ["Half-and-half"],
                             "Hawaiian Punch" : ["Hawaiian Punch"],
                             "Heavy cream" : ["Heavy cream"],
                             "Honey" : ["Honey"],
                             "Hot chocolate" : ["Hot chocolate"],
                             "Hot Damn" : ["Hot Damn"],
                             "Hpnotiq" : ["Hpnotiq"],
                             "Ice" : ["Ice"],
                             "Iced tea" : ["Iced tea"],
                             "Irish cream" : ["Irish cream"],
                             "Irish whiskey" : ["Irish whiskey"],
                             "Jack Daniels" : ["Jack Daniels"],
                             "Jägermeister" : ["Jägermeister"],
                             "Jello" : ["Jello"],
                             "Jim Beam" : ["Jim Beam"],
                             "Johnnie Walker" : ["Johnnie Walker"],
                             "Kahlua" : ["Kahlua", "Coffee liqueur"],
                             "Key Largo schnapps" : ["Key Largo schnapps"],
                             "Kiwi" : ["Kiwi"],
                             "Kiwi liqueur" : ["Kiwi liqueur"],
                             "Kool-Aid" : ["Kool-Aid"],
                             "Kummel" : ["Kummel"],
                             "Lager" : ["Lager"],
                             "Lemon" : ["Lemon"],
                             "Lemon juice" : ["Lemon juice"],
                             "Lemon peel" : ["Lemon peel"],
                             "Lemon vodka" : ["Lemon vodka"],
                             "Lemon-lime soda" : ["Lemon-lime soda"],
                             "Lemonade" : ["Lemonade"],
                             "Light rum" : ["Light rum"],
                             "Lime" : ["Lime"],
                             "Lime juice" : ["Lime juice"],
                             "Lime juice cordial" : ["Lime juice cordial"],
                             "Lime vodka" : ["Lime vodka"],
                             "Limeade" : ["Limeade"],
                             "Malibu rum" : ["Malibu rum"],
                             "Mango" : ["Mango"],
                             "Maraschino cherry juice" : ["Maraschino cherry juice"],
                             "Maui" : ["Maui"],
                             "Melon liqueur" : ["Melon liqueur"],
                             "Melon vodka" : ["Melon vodka"],
                             "Midori melon liqueur" : ["Midori melon liqueur"],
                             "Milk" : ["Milk"],
                             "Mint" : ["Mint"],
                             "Mountain Dew" : ["Mountain Dew"],
                             "Orange" : ["Orange"],
                             "Orange bitters" : ["Orange bitters"],
                             "Orange Curacao" : ["Orange Curacao"],
                             "Orange juice" : ["Orange juice"],
                             "Orange liqueur" : ["Orange liqueur"],
                             "Orange peel" : ["Orange peel"],
                             "Orange rum" : ["Orange rum"],
                             "Orange soda" : ["Orange soda"],
                             "Orange vodka" : ["Orange vodka"],
                             "Ouzo" : ["Ouzo"],
                             "Passion fruit juice" : ["Passion fruit juice"],
                             "Peach brandy" : ["Peach brandy"],
                             "Peach liqueur" : ["Peach liqueur"],
                             "Peach nectar" : ["Peach nectar"],
                             "Peach schnapps" : ["Peach schnapps"],
                             "Peach Vodka" : ["Peach Vodka"],
                             "Peachtree schnapps" : ["Peachtree schnapps"],
                             "Peppermint schnapps" : ["Peppermint schnapps"],
                             "Pernod" : ["Pernod"],
                             "Pineapple" : ["Pineapple"],
                             "Pineapple juice" : ["Pineapple juice"],
                             "Pink lemonade" : ["Pink lemonade"],
                             "Pisang Ambon" : ["Pisang Ambon"],
                             "Pisco" : ["Pisco"],
                             "Plums" : ["Plums"],
                             "Port" : ["Port"],
                             "Raisins" : ["Raisins"],
                             "Raspberry schnapps" : ["Raspberry schnapps"],
                             "Raspberry vodka" : ["Raspberry vodka"],
                             "Red wine" : ["Red wine"],
                             "Ricard" : ["Ricard"],
                             "Root beer" : ["Root beer"],
                             "Root beer schnapps" : ["Root beer schnapps"],
                             "Rum" : ["Rum"],
                             "Rumple Minze" : ["Rumple Minze"],
                             "Rye whiskey" : ["Rye whiskey"],
                             "Sake" : ["Sake"],
                             "Salt" : ["Salt"],
                             "Sambuca" : ["Sambuca"],
                             "Schnapps" : ["Schnapps"],
                             "Schweppes Russchian" : ["Schweppes Russchian"],
                             "Scotch" : ["Scotch"],
                             "Sherbet" : ["Sherbet"],
                             "Sherry" : ["Sherry"],
                             "Sloe gin" : ["Sloe gin"],
                             "Soda water" : ["Soda water"],
                             "Soda water" : ["Club soda", "Soda water"],
                             "Sour Apple Pucker" : ["Sour Apple Pucker"],
                             "Sour mix" : ["Sour mix"],
                             "Southern Comfort" : ["Southern Comfort"],
                             "Soy milk" : ["Soy milk"],
                             "Spiced rum" : ["Spiced rum"],
                             "Sprite" : ["Sprite"],
                             "Strawberries" : ["Strawberries"],
                             "Strawberry liqueur" : ["Strawberry liqueur"],
                             "Strawberry schnapps" : ["Strawberry schnapps"],
                             "Sugar" : ["Sugar"],
                             "Sugar syrup" : ["Sugar syrup"],
                             "Swedish Punsch" : ["Swedish Punsch"],
                             "Sweet and sour" : ["Sweet and sour"],
                             "Sweet Vermouth" : ["Sweet Vermouth"],
                             "Tabasco sauce" : ["Tabasco sauce"],
                             "Tang" : ["Tang"],
                             "Tea" : ["Tea"],
                             "Tennessee whiskey" : ["Tennessee whiskey"],
                             "Tequila" : ["Tequila"],
                             "Tequila Rose" : ["Tequila Rose"],
                             "Tia maria" : ["Tia maria"],
                             "Tomato juice" : ["Tomato juice"],
                             "Triple sec" : ["Triple sec"],
                             "Tropicana" : ["Tropicana"],
                             "Tuaca" : ["Tuaca"],
                             "Vanilla" : ["Vanilla"],
                             "Vanilla ice-cream" : ["Vanilla ice-cream"],
                             "Vanilla schnapps" : ["Vanilla schnapps"],
                             "Vanilla vodka" : ["Vanilla vodka"],
                             "Vermouth" : ["Vermouth"],
                             "Vodka" : ["Vodka"],
                             "Water" : ["Water"],
                             "Watermelon schnapps" : ["Watermelon schnapps"],
                             "Whipping cream" : ["Whipping cream"],
                             "Whiskey" : ["Whiskey"],
                             "Whisky" : ["Whisky"],
                             "White chocolate liqueur" : ["White chocolate liqueur"],
                             "White Creme de Menthe" : ["White Creme de Menthe"],
                             "White rum" : ["White rum"],
                             "White wine" : ["White wine"],
                             "Wild Turkey" : ["Wild Turkey"],
                             "Wildberry schnapps" : ["Wildberry schnapps"],
                             "Worcestershire sauce" : ["Worcestershire sauce"],
                             "Yellow Chartreuse" : ["Yellow Chartreuse"],
                             "Yoghurt" : ["Yoghurt"],
                             "Yukon Jack" : ["Yukon Jack"],
                             "Zima" : ["Zima"],
                             "Tonic" : ["Club soda", "Soda water"]]

}
