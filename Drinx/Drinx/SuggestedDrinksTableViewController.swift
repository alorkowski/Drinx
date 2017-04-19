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
        getCocktailDictionaryArray {
            findMatches {
                tableView.reloadData()
            }
        }
        let myCabinet = CabinetController.shared.getMyIngredientsFromUserDefaults()
        IngredientController.share.ingredients = myCabinet
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    func findMatches(completion: () -> Void) {
        for cocktail in cocktails {
            let cocktailIngredients: Set = Set(cocktail.ingredients)
            let group = DispatchGroup()
            var groupCount = 0
            group.enter()
            groupCount += 1
            print(groupCount)
            if cocktailIngredients.isSubset(of: IngredientController.share.myCabinetIngredientStrings) {
                if cocktail.imageURLs[0] != "" {
                    let ckm = CloudKitManager()
                    if let apiID = cocktail.apiID {
                        let predicate = NSPredicate(format: "%@ = apiID", apiID)
                        let query = CKQuery(recordType: "Cocktail", predicate: predicate)
                        let queryOperation = CKQueryOperation(query: query)
                        queryOperation.recordFetchedBlock = { (record) -> Void in
                            if let tempCocktail = Cocktail(record: record) {
                                self.tempCocktails.insert(tempCocktail, at: 0)
                                group.leave()
                                groupCount -= 1
                                print(groupCount)

                            }
                        }
                        ckm.publicDatabase.add(queryOperation)
                        
                    } else {
                        self.tempCocktails.append(cocktail)
                        group.leave()
                        groupCount -= 1
                        print(groupCount)


                    }
                } else {
                    self.tempCocktails.append(cocktail)
                    group.leave()
                    groupCount -= 1
                    print(groupCount)


                }
                group.notify(queue: DispatchQueue.main, execute: {
                    self.suggestedCocktails = self.tempCocktails
                    self.tableView.reloadData()
                    print(cocktail.name)
                    print(self.tempCocktails.count)
                    print(self.suggestedCocktails.count)
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
                findMatches {
                    print(suggestedCocktails.count)
                }
                completion()
            } catch {
                print(error.localizedDescription)
                completion()
            }
        }
}





