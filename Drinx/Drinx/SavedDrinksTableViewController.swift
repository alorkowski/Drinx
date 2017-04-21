//
//  SavedDrinksTableViewController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SavedDrinksTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        CocktailController.shared.fetchMyFavoriteCocktailsFromUserDefaults()
    }
    
    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CocktailController.shared.savedCocktails.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedDrinkCell", for: indexPath) as? SavedDrinksTableViewCell else { return UITableViewCell() }
        cell.cocktail = CocktailController.shared.savedCocktails[indexPath.row]
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dvc = segue.destination as? CocktailDetailTableViewController else { return }
        let cocktail = CocktailController.shared.savedCocktails[indexPath.row]
        dvc.cocktail = cocktail
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CocktailController.shared.savedCocktails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
            CocktailController.shared.saveMyFavoriteCocktailsToUserDefaults()
        }
    }
}
