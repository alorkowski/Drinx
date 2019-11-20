import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let suggestedDrinksTableViewController = SuggestedDrinksTableViewController()
        suggestedDrinksTableViewController.tabBarItem = UITabBarItem(title: "Suggested", image: UIImage(named: "Cocktail"), tag: 0)

        let savedDrinksTableViewController = SavedDrinksTableViewController()
        savedDrinksTableViewController.tabBarItem = UITabBarItem(title: "Save", image: UIImage(named: "Save"), tag: 1)

        let searchTableViewController = SearchTableViewController()
        searchTableViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "Search"), tag: 2)

        let myCabinetTableViewController = MyCabinetCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        myCabinetTableViewController.tabBarItem = UITabBarItem(title: "My Cabinet", image: UIImage(named: "myShot"), tag: 3)

        self.viewControllers = [ UINavigationController(rootViewController: suggestedDrinksTableViewController),
                                 UINavigationController(rootViewController: savedDrinksTableViewController),
                                 UINavigationController(rootViewController: searchTableViewController),
                                 UINavigationController(rootViewController: myCabinetTableViewController) ]
    }
}
