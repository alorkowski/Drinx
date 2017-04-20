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
    var cocktails: [Cocktail] = []
    var suggestedCocktails: [Cocktail] = []
    var suggestedCocktail = [String]()
    var tempCocktails: [Cocktail] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myCabinet = CabinetController.shared.getMyIngredientsFromUserDefaults()
        IngredientController.share.ingredients = myCabinet
        
        getCocktailDictionaryArray {
            findMatches {
                tableView.reloadData()
            }
        }
        
        self.searchCocktails(for: "screw") {
            print("done")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        findMatches {
            tableView.reloadData()
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
        cell.cocktail = cocktail
        
        
        
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
    
    
    func findMatches(completion: () -> Void) {
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
                })
            }
            completion()
        }
    }
    
    func getCocktailDictionaryArray(completion: () -> Void) {
        
        guard let path = Bundle.main.path(forResource: "CocktailRecipes", ofType: "json") else {return}
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else { return }
            let cocktailsArray = jsonArray.flatMap( { Cocktail(cocktailDictionary: $0)} )
            self.cocktails = cocktailsArray
            completion()
        } catch {
            print(error.localizedDescription)
            completion()
        }
    }
    
    func searchCocktails(for searchTerm: String, completion: () -> Void) {
        
//        let cocktails = CocktailController.shared.cocktails
        
        var matchingCocktails: [Cocktail] = []
        
        for cocktail in self.cocktails {
            let lowercasedCocktailIngredients = cocktail.ingredients.flatMap( {$0.lowercased() })
            if cocktail.name.lowercased().contains(searchTerm.lowercased()) {
                matchingCocktails.append(cocktail)
            } else if lowercasedCocktailIngredients.contains(searchTerm.lowercased()) {
                matchingCocktails.append(cocktail)
            }
        }
        print("\(matchingCocktails.count)")
        completion()
    }
}





