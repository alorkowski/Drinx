import UIKit

class SuggestedDrinksTableViewController: UIViewController, TutorialDelegate {
    let tableView = UITableView()
    let suggestedDrinksViewModel = SuggestedDrinksViewModel()

    override func loadView() {
        super.loadView()
        self.setupTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Suggested"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { self.tableView.reloadData() }
        guard CabinetController.shared.cabinetHasBeenUpdated else { return }
        self.suggestedDrinksViewModel.findMatches { [weak self] in
            CabinetController.shared.cabinetHasBeenUpdated = false
            self?.tableView.reloadData()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        guard let tutorialState = self.suggestedDrinksViewModel.tutorialState,
            tutorialState.isActive
            else { return }
        self.showTutorial(viewController: self,
                          title: TutorialState.suggestedDrinksTitle,
                          message: TutorialState.suggestedDrinksMessage,
                          alertActionTitle: "OK!",
                          completion: self.suggestedDrinksViewModel.toggleTutorialStateClosure)
    }
}

// MARK: - Setup Functions
extension SuggestedDrinksTableViewController {
    private func setupTableView() {
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.dataSource = self
        self.tableView.delegate = self
        DrinkTableViewCell.register(with: self.tableView)
    }
}

// MARK: - UITableViewDataSource
extension SuggestedDrinksTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.suggestedDrinksViewModel.numberOfSuggestedCocktails
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DrinkTableViewCell.dequeue(from: tableView, for: indexPath)
        let cocktail = self.suggestedDrinksViewModel.suggestedCocktails[indexPath.row]
        cell.configure(with: cocktail)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SuggestedDrinksTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false

        let cocktailDetailTableViewModel = CocktailDetailTableViewModel()
        cocktailDetailTableViewModel.cocktail = self.suggestedDrinksViewModel.suggestedCocktails[indexPath.row]

        let cocktailDetailTableViewController = CocktailDetailTableViewController()
        cocktailDetailTableViewController.cocktailDetailTableViewModel = cocktailDetailTableViewModel
        cocktailDetailTableViewController.title = self.suggestedDrinksViewModel.suggestedCocktails[indexPath.row].name

        self.navigationController?.pushViewController(cocktailDetailTableViewController, animated: true)
    }
}
