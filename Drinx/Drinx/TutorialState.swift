import UIKit

public enum TutorialState {
    case isActive
    case isInactive

    init(isActive: Bool) {
        self = isActive ? .isActive : .isInactive
    }

    static let suggestedDrinksKey = "suggestedDrinksKey"
    static let favoriteDrinksKey = "favoriteDrinksKey"
    static let searchDrinksKey = "searchDrinksKey"
    static let myCabinetKey = "myCabinetKey"
    static let cocktailDetailKey = "cocktailDetailKey"

    static let suggestedDrinksTitle = "Suggested Drinx Tab"
    static let suggestedDrinksMessage = "This is the suggested drinks tab. Once you enter the liquors and mixers that you have in your cabinet, cocktails that you are able to mix with your ingredients will appear here."
    static let favoriteDrinksTitle = "Favorite Drinx Tab"
    static let favoriteDrinksMessage = "This is the favorite drinks tab. This is where the drinks you save will show up so you can view them later. You can swipe to delete drinks if you end up not liking them."
    static let searchDrinksTitle = "Drinx Search Tab"
    static let searchDrinksMessage = "On this tab you can search for drinks by keyword. Click a drink to view the recipe."
    static let myCabinetTitle = "My Cabinet Tab"
    static let myCabinetMessage = "This tab represents your liquor cabinet. This is where you can add all the liquor and mixers you have on hand. Each time you edit your cabinet, the suggested drinks tab will update. \n\nUse the search bar at the top to search for new liquors and mixers to add to your cabint. After searching, simply click the item to add it to your cabinet. \n\nClick on an item to delete it from your cabinet. \n\nA few common items have been added to get you started."
    static let cocktailDetailTitle = "Cocktail Recipe Details"
    static let cocktailDetailMessage = "This is what each cocktail recipe looks like. Click save in the top right corner to save a cocktail to your list of favorites."
}

extension TutorialState {
    var isActive: Bool {
        switch self {
        case .isActive: return true
        case .isInactive: return false
        }
    }

    func toggle() -> TutorialState {
        switch self {
        case .isActive:
            return .isInactive
        default:
            return .isActive
        }
    }
}
