//
//  SuggestedDrinksTableViewController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit
import CloudKit

class SuggestedDrinksTableViewController: UITableViewController {
    
    var showTutorial = true
    let cocktail = [String]()
    var cocktailDictionaries: [[String:Any]] = [[:]]
    var cocktails: [Cocktail] {
        return CocktailController.shared.cocktails
    }
    var suggestedCocktails: [Cocktail] = []
    var suggestedCocktail = [String]()
    var tempCocktails: [Cocktail] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myCabinet = CabinetController.shared.getMyIngredientsFromUserDefaults()
        IngredientController.share.ingredients = myCabinet
        tableView.separatorStyle = .none
        
        CocktailController.shared.getCocktailDictionaryArray {
            findMatches {
                self.tableView.reloadData()
                DispatchQueue.global(qos: .background).async {
                    ImageController.fetchAvailableImagesFromCloudKit(forCocktails: self.suggestedCocktails, perRecordCompletion: { (cocktail) in
                        
                        guard let cocktail = cocktail else { return }
                        if let index = self.suggestedCocktails.index(of: cocktail) {
                            self.suggestedCocktails.remove(at: index)
                            self.suggestedCocktails.insert(cocktail, at: index)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                //                    let indexPath = IndexPath(row: index, section: 0)
                                //                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    })
                }
            }
        }
        if suggestedCocktails.count == 0 {
            self.suggestedCocktails = CocktailController.getRandomCocktails(numberOfCocktailsToGet: 10)
        }
        if let showTutorial = UserDefaults.standard.object(forKey: "showTutorialSuggested") as? Bool {
            self.showTutorial = showTutorial
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSuggested")
        } else {
            self.showTutorial = true
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSuggested")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor.white
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 45, right: 0)
        self.view.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        if CabinetController.shared.cabinetHasBeenUpdated {
            findMatches {
                CabinetController.shared.cabinetHasBeenUpdated = false
                self.tableView.reloadData()
                DispatchQueue.global(qos: .background).async {
                    ImageController.fetchAvailableImagesFromCloudKit(forCocktails: self.suggestedCocktails, perRecordCompletion: { (cocktail) in
                        
                        guard let cocktail = cocktail else { return }
                        if let index = self.suggestedCocktails.index(of: cocktail) {
                            self.suggestedCocktails.remove(at: index)
                            self.suggestedCocktails.insert(cocktail, at: index)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                //                    let indexPath = IndexPath(row: index, section: 0)
                                //                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.showTutorial {
            TutorialController.shared.drinksTutorial(viewController: self, title: TutorialController.shared.suggestedDrinksTitle, message: TutorialController.shared.suggestedDrinksMessage, alertActionTitle: "OK!", completion: {
                self.showTutorial = false
                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSuggested")
            })
        }
    }
    
    // MARK: - Tableview Data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.suggestedCocktails.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "suggestCell", for: indexPath) as? SuggestedTableViewCell else {return UITableViewCell() }
        
        let cocktail = suggestedCocktails[indexPath.row]
        cell.update(cocktail: cocktail)
        
        
        
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath)
    }
    
    
    // MARK: - Navigation
    
    
    //     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? CocktailDetailTableViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let cocktail = suggestedCocktails[indexPath.row]
                dvc.cocktail = cocktail
            }
        }
    }
    
    
    func findMatches(completion: @escaping () -> Void) {
        var count = 0
        var sugCocktails: [Cocktail] = []
        for cocktail in cocktails {
            let cocktailIngredients: Set = Set(cocktail.ingredients)
            if cocktailIngredients.isSubset(of: IngredientController.share.myCabinetIngredientStrings) {
                sugCocktails.append(cocktail)
            }
            count += 1
            print(count)
        }
        self.suggestedCocktails = sugCocktails
        self.tableView.reloadData()
    }
}





