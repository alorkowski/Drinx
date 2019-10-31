//
//  TutorialController.swift
//  Drinx
//
//  Created by Jeremiah Hawks on 4/23/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

final class TutorialController {
    static let shared = TutorialController()
    var showTutorial = false
    
    let suggestedDrinksTitle = "Suggested Drinx Tab"
    
    let suggestedDrinksMessage = "This is the suggested drinks tab. Once you enter the liquors and mixers that you have in your cabinet, cocktails that you are able to mix with your ingredients will appear here."
    
    let favoriteDrinksTitle = "Favorite Drinx Tab"
    
    let favoriteDrinksMessage = "This is the favorite drinks tab. This is where the drinks you save will show up so you can view them later. You can swipe to delete drinks if you end up not liking them."
    
    let searchDrinksTitle = "Drinx Search Tab"
    
    let searchDrinksMessage = "On this tab you can search for drinks by keyword. Click a drink to view the recipe."
    
    let myCabinetTitle = "My Cabinet Tab"
    
    let myCabinetMessage = "This tab represents your liquor cabinet. This is where you can add all the liquor and mixers you have on hand. Each time you edit your cabinet, the suggested drinks tab will update. \n\nUse the search bar at the top to search for new liquors and mixers to add to your cabint. After searching, simply click the item to add it to your cabinet. \n\nClick on an item to delete it from your cabinet. \n\nA few common items have been added to get you started."
    
    let cocktailDetailTitle = "Cocktail Recipe Details"
    
    let cocktailDetailMessage = "This is what each cocktail recipe looks like. Click save in the top right corner to save a cocktail to your list of favorites."
    
    var shouldPresentTutorial = true
    
    func drinksTutorial(viewController: UIViewController,
                        title: String,
                        message: String,
                        alertActionTitle: String,
                        completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let showMeTheNextTab = UIAlertAction(title: alertActionTitle, style: .cancel) { (_) in
            completion()
        }
        alert.addAction(showMeTheNextTab)
        viewController.present(alert, animated: true)
    }
    
    func saveShowTutorialToUserDefaults() {
        UserDefaults.standard.set(TutorialController.shared.showTutorial, forKey: "showTutorial")
    }
}
