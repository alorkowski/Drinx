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
    
    var cocktails: [Cocktail] = []
    var filterCocktail = [Cocktail]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
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

    
    
    
    
    func filterContentForSearchText(_ searchText: String) {
        filterCocktail = cocktails.filter({( cocktail : Cocktail) -> Bool in
            return cocktail.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
      // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return cocktails.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
     
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.presentingViewController?.performSegue(withIdentifier: "toCoktailDetail", sender: cell)
    }
}


extension SearchTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text else { return }
        
//        CocktailController.shared.searchCocktails
    }
}

