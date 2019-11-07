//
//  SearchTableViewController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/11/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class SearchTableViewController: UITableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var filterCocktail = [Cocktail]()
    var showTutorial = true

    var cocktails = [Cocktail]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.searchBar.showsCancelButton = true
        self.showTutorial = ( UserDefaults.standard.object(forKey: "showTutorialSearch") as? Bool ) ?? true
        UserDefaults.standard.set(self.showTutorial, forKey: "showTutorialSearch")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 50, right: 0))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cocktails = CocktailController.shared.cocktails
        self.tableView.reloadData()
        guard self.showTutorial else { return }
        TutorialController.shared.drinksTutorial(viewController: self,
                                                 title: TutorialController.shared.searchDrinksTitle,
                                                 message: TutorialController.shared.searchDrinksMessage,
                                                 alertActionTitle: "OK!") { [weak self] in
            self?.showTutorial = false
            UserDefaults.standard.set(self?.showTutorial, forKey: "showTutorialSearch")
        }
    }
}

// MARK: - UITableViewDataSource
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return cocktails.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
}

// MARK: - UITableViewDelegate
extension SearchTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        self.presentingViewController?.performSegue(withIdentifier: "toCoktailDetail", sender: cell)
    }
}

// MARK: - Navigation
extension SearchTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow,
            let dvc = segue.destination as? CocktailDetailTableViewController else { return }
        if let transitionStyle = UIModalTransitionStyle(rawValue: 2) {
            dvc.modalTransitionStyle = transitionStyle
        }
        let cocktail = self.cocktails[indexPath.row]
        dvc.cocktail = cocktail
    }
}

// MARK: - UISearchBarDelegate
extension SearchTableViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchTerm = searchBar.text else { return }
        guard searchTerm.count >= 3 else { return }
        self.cocktails = []
        self.tableView.reloadData()
        CocktailController.shared.searchCocktails(for: searchTerm, perRecordCompletion: { cocktail in
            if !self.cocktails.contains(cocktail) {
                self.cocktails.append(cocktail)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }

        }) {}
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        guard let searchTerm = searchBar.text else { return }
        guard searchTerm != "" else {
            self.cocktails = CocktailController.shared.cocktails
            self.tableView.reloadData()
            return
        }

        let perRecordCompletion: (Cocktail) -> Void = { [weak self] cocktail in
            guard !(self?.cocktails.contains(cocktail) ?? false) else { return }
            self?.cocktails.append(cocktail)
            self?.tableView.reloadData()
        }

        let completion: () -> Void = {
            DispatchQueue.global(qos: .background).async {
                ImageController.fetchAvailableImagesFromCloudKit(forCocktails: self.cocktails) { [weak self] (cocktail) in
                    guard let cocktail = cocktail else { return }
                    guard let index = self?.cocktails.firstIndex(of: cocktail) else { return }
                    self?.cocktails.remove(at: index)
                    self?.cocktails.insert(cocktail, at: index)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                }
            }
        }

        self.cocktails = []
        CocktailController.shared.searchCocktails(for: searchTerm,
                                                  perRecordCompletion: perRecordCompletion,
                                                  completion: completion)
    }
}
