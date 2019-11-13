import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let suggestedDrinksTableViewController = SuggestedDrinksTableViewController()
        suggestedDrinksTableViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        self.viewControllers = [suggestedDrinksTableViewController]
    }
}
