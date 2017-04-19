//
//  MyCabinetCollectionViewController.swift
//  Drinx
//
//  Created by DANIEL CORNWELL on 4/12/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MyCabinetCollectionViewController: UICollectionViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        let myIngredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        IngredientController.share.ingredients = myIngredients
        setUpSearchController()

//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            var cellSize = UIScreen.main.bounds.size
            cellSize.width *= 0.45
            cellSize.height = cellSize.width + 30
            layout.itemSize = cellSize
        }
//        searchController?.searchBar.text = ""
    }
    
    
    
//    override func didMove(toParentViewController parent: UIViewController?) {
//        searchController?.searchBar.text = ""
//    }
    
    //=======================================================
    // MARK: - Setup SearchController
    //=======================================================
    
    private func setUpSearchController() {
        
        let resultsController = UIStoryboard(name: "MyCabinet", bundle: nil).instantiateViewController(withIdentifier: "ingredentSearchResultsTVC")
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.searchBar.delegate = self
        
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let resultsViewController = searchController.searchResultsController as? ingredentSearchResultsTVC,
            let searchTerm = searchController.searchBar.text?.lowercased() {
            let ingredients = IngredientController.share.ingredientStrings
            var matchingIngredients: [Ingredient] = []
            for ingredient in ingredients {
                if ingredient.lowercased().contains(searchTerm) {
                    let ingObj = Ingredient(name: ingredient)
                    if !IngredientController.share.ingredients.contains(ingObj) {
                        matchingIngredients.append(ingObj)
                    }
                }
            }
            
            resultsViewController.resultsArray = matchingIngredients
            CabinetController.shared.myCabinet.myIngredients = IngredientController.share.ingredients
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController?.searchBar.text = ""
        self.collectionView?.reloadData()
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

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

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
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
        }
        alertControler.addAction(cancelAction)
        alertControler.addAction(deleteAction)
        self.present(alertControler, animated: true) {
        }
    }

}
