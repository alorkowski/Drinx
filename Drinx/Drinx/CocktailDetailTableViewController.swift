//
//  CocktailDetailTableViewController.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class CocktailDetailTableViewController: UITableViewController {
    
    var showTutorial = true
    
    let mockCocktail = ["idDrink":"15112","strDrink":"Alamo Splash","strCategory":"Ordinary Drink","strAlcoholic":"Alcoholic","strGlass":"Collins glass","strInstructions":"Mix with cracked ice and strain into collins glass.","strDrinkThumb":"","strIngredient1":"Tequila","strIngredient2":"Orange juice","strIngredient3":"Pineapple juice","strIngredient4":"Lemon-lime soda","strIngredient5":"","strIngredient6":"","strIngredient7":"","strIngredient8":"","strIngredient9":"","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strMeasure1":"1 1/2 oz ","strMeasure2":"1 oz ","strMeasure3":"1/2 oz ","strMeasure4":"1 splash ","strMeasure5":" ","strMeasure6":" ","strMeasure7":" ","strMeasure8":" ","strMeasure9":" ","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","dateModified":""]

    var cocktail: Cocktail?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        if let showTutorial = UserDefaults.standard.object(forKey: "showTutorialCocktailDetail") as? Bool {
            self.showTutorial = showTutorial
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialCocktailDetail")
        } else {
            self.showTutorial = true
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialCocktailDetail")
        }

    }
    

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor.white
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        self.view.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.showTutorial {
            TutorialController.shared.drinksTutorial(viewController: self,
                                                     title: TutorialController.shared.cocktailDetailTitle,
                                                     message: TutorialController.shared.cocktailDetailMessage,
                                                     alertActionTitle: "OK!",
                                                     completion: {
                self.showTutorial = false
                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialCocktailDetail")
            })
        }
    }
    
    
    func setNavigationBar() {
        
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        if let cocktail = cocktail {
            navItem.title = cocktail.name

        }
        navBar.backgroundColor =  UIColor(red: 141/255, green: 162/255, blue: 110/255, alpha: 1.0)
        navBar.tintColor = UIColor(red: 141/255, green: 162/255, blue: 110/255, alpha: 1.0)
        let backItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: #selector(done))
        let favoriteItem = UIBarButtonItem(title: "Save", style: .plain, target: nil, action: #selector(saveCocktailToFavorites))
        navItem.leftBarButtonItem = backItem
        navItem.rightBarButtonItem = favoriteItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }
    
    func saveCocktailToFavorites() {
        if let cocktail = cocktail {
            CocktailController.shared.savedCocktails.append(cocktail)
            CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
        }
        self.tabBarController?.selectedIndex = 2
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func done() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cocktail = cocktail else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return cocktail.ingredients.count
        case 2:
            return 1
        default:
            break
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        default:
            break
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            //            return self.view.frame.width
            return self.view.frame.size.width
        case 1:
            return 30
        case 2:
            return 200
        default:
            break
        }
        return 30
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
//            return self.view.frame.width
            return self.view.frame.size.width
        case 1:
            return 30
        case 2:
            return UITableViewAutomaticDimension
        default:
            break
        }
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as? CockailDetailImageTableViewCell else { return UITableViewCell() }
            cell.cocktail = cocktail
//            cell.imageView?.frame.width = self.view.frame.width
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath) as? CocktailDetailIngredientTableViewCell else { return UITableViewCell() }
            cell.cocktail = cocktail
            if let ingredient = cocktail?.ingredients[indexPath.row], let amount = cocktail?.ingredientProportions[indexPath.row] {
                cell.textLabel?.text = "\(ingredient) - \(amount)"
            }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell", for: indexPath) as? CocktailDetailInstructionTableViewCell else { return UITableViewCell() }
            cell.cocktail = cocktail
            if let instructions = cocktail?.instructions {
                cell.textLabel?.text = instructions
            }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
//    func updateViews() {
//        
//        let ingredientString = cocktail?.ingredients.joined(separator: ", ")
//        
////        cocktailImageView.image = cocktail?.image
//        cocktailInstructionsLabel.text = cocktail?.instructions
//        cocktailIngredientsLabel.text = ingredientString
//        
//    }
    
    // Mark: - UITableViewDelegate
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.row {
//        case 0:
//            return 53
//            
//        case 1:
//            
//            let screenWidth = self.view.frame.width
//            
//            guard let cocktailImage = self.cocktail?.image else { return screenWidth }
//            
//            let imageHeight = cocktailImage.size.height
//            let imageWidth = cocktailImage.size.width
//            
//            let imageAspectRatio = imageWidth / imageHeight
//            
//            let cellHeight = self.view.frame.width / imageAspectRatio
//            
//            return cellHeight
//            
//        case 2:
//            return 202
//            
//        default:
//            return 40
//        }
//        
//    }

}
