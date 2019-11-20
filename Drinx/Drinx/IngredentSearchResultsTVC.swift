import UIKit
import NotificationCenter

final class IngredientSearchResultsTVC: UITableViewController {
    var resultsArray: [Ingredient] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppFeatures.backgroundColor
        self.setupTableView()
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = IngredientsSearchResultsTableViewCell.dequeue(from: tableView, for: indexPath)
        cell.configure(with: self.resultsArray[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension IngredientSearchResultsTVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredientString = self.resultsArray[indexPath.row].name
        IngredientController.shared.add(item: ingredientString)
        CabinetController.shared.saveMyCabinetToUserDefaults()
        CabinetController.shared.cabinetHasBeenUpdated = true
        let nc = NotificationCenter.default
        let notification = Notification.Name(rawValue: "updateMyCabinet")
        nc.post(name: notification, object: nil)
        self.dismiss(animated: true)
    }
}
