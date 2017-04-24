//
//  SearchTableViewController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var showTutorial = true
    
    var cocktails: [Cocktail] = [] {
        didSet {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    var filterCocktail = [Cocktail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        if let showTutorial = UserDefaults.standard.object(forKey: "showTutorialSearch") as? Bool {
            self.showTutorial = showTutorial
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSearch")
        } else {
            self.showTutorial = true
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSearch")
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor.white
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 45, right: 0)
        self.view.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.showTutorial {
            self.searchBar.text = "Rum"
            self.searchBarSearchButtonClicked(self.searchBar)
            TutorialController.shared.drinksTutorial(viewController: self, title: TutorialController.shared.searchDrinksTitle, message: TutorialController.shared.searchDrinksMessage, alertActionTitle: "OK!", completion: { 
                self.showTutorial = false
                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSearch")
            })
        }
    }
    
    
      // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cocktails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        let cocktail = self.cocktails[indexPath.row]
        
        cell.textLabel?.text = cocktail.name
        
        if cocktail.image != nil {
            cell.imageView?.image = cocktail.image
        } else {
            if let image = UIImage(named: cocktail.ingredients[0]) {
                cell.imageView?.image = image
            } else if let image = UIImage(named: cocktail.ingredients[1]) {
                cell.imageView?.image = image
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.presentingViewController?.performSegue(withIdentifier: "toCoktailDetail", sender: cell)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dvc = segue.destination as? CocktailDetailTableViewController else { return }
        let cocktail = self.cocktails[indexPath.row]
        dvc.cocktail = cocktail
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text else { return }
        
        CocktailController.shared.searchCocktails(for: searchTerm) { (cocktails) in
            self.cocktails = cocktails
            DispatchQueue.global(qos: .background).async {
            for cocktail in CocktailController.shared.cocktails {
                for ingredient in cocktail.ingredients {
                    if ingredient.lowercased().contains(searchTerm.lowercased()) {
                        if !self.cocktails.contains(cocktail) {
                            self.cocktails.append(cocktail)
                        }
                    }
                }
            }
                ImageController.fetchAvailableImagesFromCloudKit(forCocktails: self.cocktails, perRecordCompletion: { (cocktail) in
                    
                    guard let cocktail = cocktail else { return }
                    if let index = self.cocktails.index(of: cocktail) {
                        self.cocktails.remove(at: index)
                        self.cocktails.insert(cocktail, at: index)
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

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resignFirstResponder()
        guard let searchTerm = searchBar.text else { return }
        
        CocktailController.shared.searchCocktails(for: searchTerm) { (cocktails) in
            self.cocktails = cocktails
            DispatchQueue.global(qos: .background).async {
            for cocktail in CocktailController.shared.cocktails {
                for ingredient in cocktail.ingredients {
                    if ingredient.lowercased().contains(searchTerm.lowercased()) {
                        if !self.cocktails.contains(cocktail) {
                            self.cocktails.append(cocktail)
                        }
                    }
                }
            }
                ImageController.fetchAvailableImagesFromCloudKit(forCocktails: self.cocktails, perRecordCompletion: { (cocktail) in
                    
                    guard let cocktail = cocktail else { return }
                    if let index = self.cocktails.index(of: cocktail) {
                        self.cocktails.remove(at: index)
                        self.cocktails.insert(cocktail, at: index)
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

