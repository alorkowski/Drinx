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
        
        CocktailController.shared.getCocktailDictionaryArray {
            findMatches {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if CabinetController.shared.cabinetHasBeenUpdated{
            findMatches {
                self.tableView.reloadData()
                CabinetController.shared.cabinetHasBeenUpdated = false
            }
        }
        
    }
    
    // MARK: - Tableview Data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return suggestedCocktails.count
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
        for cocktail in cocktails {
            let cocktailIngredients: Set = Set(cocktail.ingredients)
            let group = DispatchGroup()
            var groupCount = 0
            group.enter()
            groupCount += 1
//            print(groupCount)
            if cocktailIngredients.isSubset(of: IngredientController.share.myCabinetIngredientStrings) {
                if cocktail.imageURLs[0] != "" {
                    let ckm = CloudKitManager()
                    if let apiID = cocktail.apiID {
                        let predicate = NSPredicate(format: "%@ = apiID", apiID)
                        let query = CKQuery(recordType: "Cocktail", predicate: predicate)
                        let queryOperation = CKQueryOperation(query: query)
                        queryOperation.recordFetchedBlock = { (record) -> Void in
                            if let tempCocktail = Cocktail(record: record) {
                                if !self.tempCocktails.contains(tempCocktail) {
                                    self.tempCocktails.insert(tempCocktail, at: 0)
                                }
                                group.leave()
                                groupCount -= 1
//                                print(groupCount)
                                
                            }
                        }
                        ckm.publicDatabase.add(queryOperation)
                        
                    } else {
                        if !self.tempCocktails.contains(cocktail) {
                            self.tempCocktails.append(cocktail)
                        }
                        group.leave()
                        groupCount -= 1
//                        print(groupCount)
                        
                        
                    }
                } else {
                    if !self.tempCocktails.contains(cocktail) {
                        self.tempCocktails.append(cocktail)
                    }
                    group.leave()
                    groupCount -= 1
//                    print(groupCount)
                    
                    
                }
                group.notify(queue: DispatchQueue.main, execute: {
                    self.suggestedCocktails = self.tempCocktails
                    self.tableView.reloadData()
//                    print(cocktail.name)
//                    print(self.tempCocktails.count)
//                    print(self.suggestedCocktails.count)
                    completion()
                })
            }
        }
    }
    
}





