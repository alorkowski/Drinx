//
//  ingredentSearchResultsTVC.swift
//  Drinx
//
//  Created by Angela Montierth on 4/19/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class ingredentSearchResultsTVC: UITableViewController {
    
    var resultsArray: [Ingredient] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

       // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0)
        
        self.view.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientSearchResultCell", for: indexPath) as? IngredientsSearchResultsTableViewCell else { return UITableViewCell() }
        let ingredientString = resultsArray[indexPath.row]
        cell.ingredient = ingredientString
        cell.imageLabel?.isHidden = false
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredientString = resultsArray[indexPath.row].name
        IngredientController.share.add(item: ingredientString)
        CabinetController.shared.cabinetHasBeenUpdated = true
        self.dismiss(animated: true, completion: nil)
    }
    

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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
