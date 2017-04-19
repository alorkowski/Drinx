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
    
    let myCabinetIngredients =  CabinetController.shared.myCabinet.myIngredients
    
    let haveIngredient = false
    
    let cocktail = [String]()
    
    var cocktailDictionaries: [[String:Any]] = [[:]]
    var cocktails: [Cocktail] = []
    var suggestedCocktails: [Cocktail] = []
    
    
    var suggestedCocktail = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        getCocktailDictionaryArray()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func findMatches(completion: () -> Void) {
        for cocktail in cocktails {
            let cocktailIngredients: Set = Set(cocktail.ingredients)
            if cocktailIngredients.isSubset(of: CocktailController.shared.mockIngredients) {
             self.suggestedCocktails.append(cocktail)
            }
        }
        completion()
    }
    
    func getCocktailDictionaryArray() {
        
        guard let path = Bundle.main.path(forResource: "CocktailRecipes", ofType: "json") else {return}
        do {
            
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] else {return}
            
            
            let cocktailsArray = jsonArray.flatMap( { Cocktail(cocktailDictionary: $0)} )
            self.cocktails = cocktailsArray
            findMatches {
                print(suggestedCocktails.count)
            }
        } catch {
            print(error.localizedDescription)
            
        }
    }
}





