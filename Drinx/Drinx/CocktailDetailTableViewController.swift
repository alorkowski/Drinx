//
//  CocktailDetailTableViewController.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class CocktailDetailTableViewController: UITableViewController {
    var showTutorial = true
    let mockCocktail = ["idDrink":"15112","strDrink":"Alamo Splash","strCategory":"Ordinary Drink","strAlcoholic":"Alcoholic","strGlass":"Collins glass","strInstructions":"Mix with cracked ice and strain into collins glass.","strDrinkThumb":"","strIngredient1":"Tequila","strIngredient2":"Orange juice","strIngredient3":"Pineapple juice","strIngredient4":"Lemon-lime soda","strIngredient5":"","strIngredient6":"","strIngredient7":"","strIngredient8":"","strIngredient9":"","strIngredient10":"","strIngredient11":"","strIngredient12":"","strIngredient13":"","strIngredient14":"","strIngredient15":"","strMeasure1":"1 1/2 oz ","strMeasure2":"1 oz ","strMeasure3":"1/2 oz ","strMeasure4":"1 splash ","strMeasure5":" ","strMeasure6":" ","strMeasure7":" ","strMeasure8":" ","strMeasure9":" ","strMeasure10":"","strMeasure11":"","strMeasure12":"","strMeasure13":"","strMeasure14":"","strMeasure15":"","dateModified":""]

    var cocktail: Cocktail?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 44
        self.tableView.allowsSelection = false
        self.showTutorial = ( UserDefaults.standard.object(forKey: "showTutorialCocktailDetail") as? Bool ) ?? true
        UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialCocktailDetail")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard self.showTutorial else { return }
        TutorialController
            .shared
            .drinksTutorial(viewController: self,
                            title: TutorialController.shared.cocktailDetailTitle,
                            message: TutorialController.shared.cocktailDetailMessage,
                            alertActionTitle: "OK!") {
                                self.showTutorial = false
                                UserDefaults.standard.set(self.showTutorial,
                                                          forKey: "showTutorialCocktailDetail")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
}

// MARK: - Setup functions
extension CocktailDetailTableViewController {
    func setNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let navItem = UINavigationItem(title: "")
        if let cocktail = cocktail { navItem.title = cocktail.name }
        navBar.backgroundColor =  UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        navBar.tintColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        let backItem = UIBarButtonItem(title: "Back", style: .done, target: nil, action: #selector(done))
        let favoriteItem = UIBarButtonItem(title: "Save",
                                           style: .plain,
                                           target: nil,
                                           action: #selector(saveCocktailToFavorites))
        navItem.leftBarButtonItem = backItem
        navItem.rightBarButtonItem = favoriteItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
    }

    @objc func saveCocktailToFavorites() {
        if let cocktail = cocktail {
            if !CocktailController.shared.savedCocktails.contains(cocktail) {
                CocktailController.shared.savedCocktails.append(cocktail)
                CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
            }
        }
        self.resignFirstResponder()
        self.dismiss(animated: true) { self.tabBarController?.selectedIndex = 1 }
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    @objc func done() {
        self.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension CocktailDetailTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let cocktail = cocktail else { return 0 }
        switch section {
        case 0:
            return 1
        case 1:
            return cocktail.ingredients.count
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 0
        case 2:
            return 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView,
                            estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.view.frame.size.width + 44
        case 1:
            return 30
        case 2:
            return 200
        default:
            return 30
        }
    }

    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.view.frame.size.width + 44
        case 1:
            return 30
        case 2:
            return UITableView.automaticDimension
        default:
            return 30
        }
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell",
                                                     for: indexPath) as! CockailDetailImageTableViewCell
            cell.cocktail = cocktail
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell",
                                                     for: indexPath) as! CocktailDetailIngredientTableViewCell
            cell.cocktail = cocktail
            if let ingredient = cocktail?.ingredients[indexPath.row],
                let amount = cocktail?.ingredientProportions[indexPath.row] {
                cell.textLabel?.text = "\(ingredient) - \(amount)"
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "instructionCell",
                                                     for: indexPath) as! CocktailDetailInstructionTableViewCell
            cell.cocktail = cocktail
            if let instructions = cocktail?.instructions { cell.textLabel?.text = instructions }
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.sizeToFit()
            return cell
        default:
            return UITableViewCell()
        }
    }
}
