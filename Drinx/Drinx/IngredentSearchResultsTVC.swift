import UIKit
import NotificationCenter

final class IngredientSearchResultsTVC: UITableViewController {
    var resultsArray: [Ingredient] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppFeatures.backgroundColor
        self.setupTableView()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 44, right: 0))
    }
}

// MARK: - Setup Functions
extension IngredientSearchResultsTVC {
    private func setupTableView() {
        self.tableView.backgroundColor = .clear
        IngredientsSearchResultsTableViewCell.register(with: self.tableView)
    }
}

// MARK: - UITableViewDataSource
extension IngredientSearchResultsTVC {
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return resultsArray.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IngredientsSearchResultsTableViewCell.dequeue(from: tableView, for: indexPath)
        cell.configure(with: resultsArray[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension IngredientSearchResultsTVC {
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        let ingredientString = resultsArray[indexPath.row].name
        IngredientController.shared.add(item: ingredientString)
        CabinetController.shared.saveMyCabinetToUserDefaults()
        CabinetController.shared.cabinetHasBeenUpdated = true
        let nc = NotificationCenter.default
        let notification = Notification.Name(rawValue: "updateMyCabinet")
        nc.post(name: notification, object: nil)
        self.dismiss(animated: true)
    }
}
