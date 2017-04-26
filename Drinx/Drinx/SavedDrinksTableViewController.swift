//
//  SavedDrinksTableViewController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SavedDrinksTableViewController: UITableViewController {
    
    var showTutorial = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        CocktailController.shared.fetchMyFavoriteCocktailsFromUserDefaults()
        DispatchQueue.global(qos: .background).async {
            ImageController.fetchAvailableImagesFromCloudKit(forCocktails: CocktailController.shared.savedCocktails, perRecordCompletion: { (cocktail) in
                
                guard let cocktail = cocktail else { return }
                if let index = CocktailController.shared.savedCocktails.index(of: cocktail) {
                    CocktailController.shared.savedCocktails.remove(at: index)
                    CocktailController.shared.savedCocktails.insert(cocktail, at: index)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        //                    let indexPath = IndexPath(row: index, section: 0)
                        //                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            })
        }
        if CocktailController.shared.savedCocktails.isEmpty {
            CocktailController.shared.savedCocktails = CocktailController.shared.sampleSavedCocktails
        }
        if let showTutorial = UserDefaults.standard.object(forKey: "showTutorialSaved") as? Bool {
            self.showTutorial = showTutorial
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSaved")
        } else {
            self.showTutorial = true
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSaved")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 44, right: 0)
        self.view.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
    }
    
    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.showTutorial {
            TutorialController.shared.drinksTutorial(viewController: self, title: TutorialController.shared.favoriteDrinksTitle, message: TutorialController.shared.favoriteDrinksMessage, alertActionTitle: "OK!") {
                self.showTutorial = false
                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSaved")
            }
        }
        
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
        if let transitionStyle = UIModalTransitionStyle(rawValue: 2) {
            dvc.modalTransitionStyle = transitionStyle
        }
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
