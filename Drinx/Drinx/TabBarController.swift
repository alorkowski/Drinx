import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let suggestedDrinksTableViewController = SuggestedDrinksTableViewController()
        suggestedDrinksTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let myDrinksTableViewController = MyDrinksTableViewController()
        myDrinksTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 1)

        let searchTableViewController = SearchTableViewController()
        searchTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)

        self.viewControllers = [ UINavigationController(rootViewController: suggestedDrinksTableViewController),
                                 myDrinksTableViewController,
                                 searchTableViewController ]
    }
}
