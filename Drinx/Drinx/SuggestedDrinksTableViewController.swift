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
        self.title = TutorialState.suggestedDrinksTitle
        self.tableView.dataSource = self
        self.tableView.delegate = self
        SuggestedTableViewCell.register(with: self.tableView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.view.superview!.backgroundColor = UIColor(red: 0/255, green: 165/255, blue: 156/255, alpha: 1.0)
        self.view.frame = self.view.superview!.bounds
        self.view.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 45, right: 0))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
        let cell = SuggestedTableViewCell.dequeue(from: tableView, for: indexPath)
        let cocktail = self.suggestedDrinksViewModel.suggestedCocktails[indexPath.row]
        cell.update(cocktail: cocktail)
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
