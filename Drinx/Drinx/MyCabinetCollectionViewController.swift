//
//  MyCabinetCollectionViewController.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MyCabinetCollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    var searchController: UISearchController?
    
    var showTutorial = true
    
    var ddidLayout = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myIngredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        if myIngredients.count != 0 {
            CabinetController.shared.myCabinet.myIngredients = myIngredients
            IngredientController.share.ingredients = myIngredients
            CabinetController.shared.saveMyCabinetToUserDefaults()
        } else {
            CabinetController.shared.myCabinet.myIngredients = CabinetController.shared.myCabinet.sampleIngredients
            IngredientController.share.ingredients = CabinetController.shared.myCabinet.sampleIngredients
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
        setUpSearchController()
        if let showTutorial = UserDefaults.standard.object(forKey: "showTutorialMyCabinet") as? Bool {
            self.showTutorial = showTutorial
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialMyCabinet")
        } else {
            self.showTutorial = true
            UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialMyCabinet")
        }

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        var insets = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        self.collectionView?.frame = UIEdgeInsetsInsetRect(self.view.superview!.bounds, insets)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            var cellSize = UIScreen.main.bounds.size
            cellSize.width *= 0.45
            cellSize.height = cellSize.width + 30
            layout.itemSize = cellSize
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.showTutorial {
            TutorialController.shared.drinksTutorial(viewController: self, title: TutorialController.shared.myCabinetTitle, message: TutorialController.shared.myCabinetMessage, alertActionTitle: "OK!", completion: { 
                self.showTutorial = false
                UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialMyCabinet")
            })
        }
    }
        
    //=======================================================
    // MARK: - Setup SearchController
    //=======================================================
    
    private func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "MyCabinet", bundle: nil).instantiateViewController(withIdentifier: "ingredentSearchResultsTVC")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        searchIngredients(searchController: searchController) { (resultsViewController) in
            resultsViewController.tableView.reloadData()
        }
    }
    
    func searchIngredients(searchController: UISearchController, completion: (_ resultsViewController: UITableViewController ) -> Void) {
        if let resultsViewController = searchController.searchResultsController as? ingredentSearchResultsTVC,
            let searchTerm = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
//            resultsViewController.tableView.tableHeaderView = searchController.searchBar
            let ingredients = IngredientController.share.ingredientDictionary.keys
            var matchingIngredients: [Ingredient] = []
            for ingredient in ingredients {
                if ingredient.lowercased().contains(searchTerm) {
                    guard let ingArray = IngredientController.share.ingredientDictionary[ingredient] else { return }
                    for ing in ingArray {
                        let ingObj = Ingredient(name: ing)
                        if !IngredientController.share.ingredients.contains(ingObj) {
                            matchingIngredients.append(ingObj)
                        }
                    }
                }
            }
            resultsViewController.resultsArray = matchingIngredients
            CabinetController.shared.myCabinet.myIngredients = IngredientController.share.ingredients
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
    }
    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchController?.searchBar.text = ""
//        self.collectionView?.reloadData()
//    }
//    
//    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let searchController = searchController else { return }
//        searchIngredients(searchController: searchController) { (resultsViewController) in
//            resultsViewController.tableView.reloadData()
//        }
//        resignFirstResponder()
//    }



    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IngredientController.share.ingredients.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCabinetCell", for: indexPath) as? MyCabinetCollectionViewCell else { return UICollectionViewCell() }
        let ingredient = IngredientController.share.ingredients[indexPath.row]
        cell.ingredient = ingredient
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "searchHeader", for: indexPath)
            if let searchController = searchController {
                view.addSubview(searchController.searchBar)
            }
            
            return view
        } else {
            return UICollectionReusableView()
        }
        
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deleteAlertController(indexPath: indexPath, ingredient: IngredientController.share.ingredients[indexPath.row])
    }
    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    
    func deleteAlertController(indexPath: IndexPath, ingredient: Ingredient) {
        let alertControler = UIAlertController(title: "Delete!", message: "Would you like to delete this item (\(IngredientController.share.ingredients[indexPath.row].name))?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            IngredientController.share.delete(ingredient: ingredient)
            self.collectionView?.reloadData()
            self.collectionView?.reloadInputViews()
            CabinetController.shared.cabinetHasBeenUpdated = true
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
        alertControler.addAction(cancelAction)
        alertControler.addAction(deleteAction)
        self.present(alertControler, animated: true) {
        }
    }

}
