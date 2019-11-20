import UIKit

typealias ResultsViewControllerHandler = (_ resultsViewController: UITableViewController ) -> Void

final class MyCabinetCollectionViewController: UICollectionViewController, TutorialDelegate {
    let myCabinetCollectionViewModel = MyCabinetCollectionViewModel()
    var searchController: UISearchController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let nc = NotificationCenter.default
        let notification = Notification.Name(rawValue: "updateMyCabinet")
        nc.addObserver(self,
                       selector: #selector(MyCabinetCollectionViewController.didUpdateMyCabinet),
                       name: notification,
                       object: nil)
        self.setupCollectionView()
        self.setUpSearchController()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        let insets = UIEdgeInsets(top: 20, left: 0, bottom: 40, right: 0)
        self.collectionView?.frame = self.view.superview!.bounds
        self.collectionView?.frame.inset(by: insets)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.collectionView?.reloadData()
        self.collectionView?.reloadInputViews()
        if let layout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            var cellSize = UIScreen.main.bounds.size
            cellSize.width *= 0.45
            cellSize.height = cellSize.width + 30
            layout.itemSize = cellSize
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView?.reloadData()
        guard self.myCabinetCollectionViewModel.tutorialState?.isActive ?? true else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.myCabinetTitle,
                          message: TutorialState.myCabinetMessage,
                          alertActionTitle: "OK!",
                          completion: self.myCabinetCollectionViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup functions
extension MyCabinetCollectionViewController {
    private func setupCollectionView() {
        MyCabinetCollectionViewCell.register(with: self.collectionView)
    }

    private func setUpSearchController() {
        self.searchController = UISearchController(searchResultsController: IngredientSearchResultsTVC())
        self.searchController?.searchResultsUpdater = self
        self.searchController?.obscuresBackgroundDuringPresentation = false
        self.searchController?.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = true
    }

    @objc func didUpdateMyCabinet() {
        self.collectionView?.reloadData()
        self.collectionView?.reloadInputViews()
    }

    func deleteAlertController(indexPath: IndexPath, ingredient: Ingredient) {
        let alertControler = UIAlertController(title: "Delete!", message: "Would you like to delete this item (\(IngredientController.shared.ingredients[indexPath.row].name))?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            IngredientController.shared.delete(ingredient: ingredient)
            self?.collectionView?.reloadData()
            self?.collectionView?.reloadInputViews()
            CabinetController.shared.cabinetHasBeenUpdated = true
            CabinetController.shared.saveMyCabinetToUserDefaults()
        }
        alertControler.addAction(cancelAction)
        alertControler.addAction(deleteAction)
        self.present(alertControler, animated: true)
    }
}

// MARK: UICollectionViewDataSource
extension MyCabinetCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return IngredientController.shared.ingredients.count
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = MyCabinetCollectionViewCell.dequeue(from: collectionView, for: indexPath)
        cell.configure(with: IngredientController.shared.ingredients[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "searchHeader",
                                                                       for: indexPath)
            if let searchController = searchController { view.addSubview(searchController.searchBar) }
            return view
        } else {
            return UICollectionReusableView()
        }
    }
}

// MARK: UICollectionViewDelegate
extension MyCabinetCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        deleteAlertController(indexPath: indexPath, ingredient: IngredientController.shared.ingredients[indexPath.row])
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 canPerformAction action: Selector,
                                 forItemAt indexPath: IndexPath,
                                 withSender sender: Any?) -> Bool {
        return false
    }
}

// MARK: - SearchControllerDelegate
extension MyCabinetCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.searchIngredients(searchController: searchController){ $0.tableView.reloadData() }
    }

    func searchIngredients(searchController: UISearchController, completion: ResultsViewControllerHandler) {
        guard let resultsViewController = searchController.searchResultsController as? IngredientSearchResultsTVC,
            let searchTerm = searchController.searchBar.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            else { return }
        let ingredients = IngredientController.shared.ingredientDictionary.keys
        var matchingIngredients: [Ingredient] = []
        for ingredient in ingredients {
            guard ingredient.lowercased().contains(searchTerm) else { continue }
            guard let ingredientArray = IngredientController.shared.ingredientDictionary[ingredient] else { return }
            for ingredientName in ingredientArray {
                let ingredientObject = Ingredient(name: ingredientName)
                if !IngredientController.shared.ingredients.contains(ingredientObject) {
                    matchingIngredients.append(ingredientObject)
                }
            }
        }
        resultsViewController.resultsArray = matchingIngredients
        CabinetController.shared.myCabinet.myIngredients = IngredientController.shared.ingredients
        CabinetController.shared.saveMyCabinetToUserDefaults()
    }
}
