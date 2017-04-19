//
//  CocktailDetailTableViewController.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CocktailDetailTableViewController: UITableViewController {
    
    
    @IBOutlet weak var cocktailImageView: UIImageView!
    @IBOutlet weak var cocktailIngredientsLabel: UILabel!
    @IBOutlet weak var cocktailInstructionsLabel: UILabel!
    
    let mockCocktail = ["idDrink":"15112","strDrink":"Alamo Splash","strCategory":"Ordinary Drink","strAlcoholic":"Alcoholic","strGlass":"Collins glass","strInstructions":"Mix with cracked ice and strain into collins glass.","strDrinkThumb":"","strIngredient1":"Tequila","strIngredient2":"Orange juice","strIngredient3":"Pineapple juice","strIngredient4":"Lemon-lime soda","strIngredient5":"","strIngredient6":"","strIngredient7":"","strIngredient8":"","strIngredient9":"","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strMeasure1":"1 1/2 oz ","strMeasure2":"1 oz ","strMeasure3":"1/2 oz ","strMeasure4":"1 splash ","strMeasure5":" ","strMeasure6":" ","strMeasure7":" ","strMeasure8":" ","strMeasure9":" ","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","dateModified":""]

    var cocktail: Cocktail?

    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.cocktail = Cocktail(cocktailDictionary: mockCocktail)
        updateViews()

    }
    
    func updateViews() {
        
        let ingredientString = cocktail?.ingredients.joined(separator: ", ")
        
//        cocktailImageView.image = cocktail?.image
        cocktailInstructionsLabel.text = cocktail?.instructions
        cocktailIngredientsLabel.text = ingredientString
        
    }
    
    // Mark: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 53
            
        case 1:
            
            let screenWidth = self.view.frame.width
            
            guard let cocktailImage = self.cocktail?.image else { return screenWidth }
            
            let imageHeight = cocktailImage.size.height
            let imageWidth = cocktailImage.size.width
            
            let imageAspectRatio = imageWidth / imageHeight
            
            let cellHeight = self.view.frame.width / imageAspectRatio
            
            return cellHeight
            
        case 2:
            return 202
            
        default:
            return 40
        }
        
    }

}
