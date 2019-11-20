import Foundation

final class MyCabinetCollectionViewModel {
    var tutorialState: TutorialState?

    lazy var toggleTutorialStateClosure = { [weak self] in
        self?.tutorialState = self?.tutorialState?.toggle()
        UserDefaults.standard.set(self?.tutorialState?.isActive, forKey: TutorialState.myCabinetKey)
    }

    init() {
        let myIngredients = CabinetController.shared.getMyIngredientsFromUserDefaults()
        CabinetController.shared.myCabinet.myIngredients = myIngredients.count != 0 ?
            CabinetController.shared.myCabinet.sampleIngredients : myIngredients
        IngredientController.shared.ingredients = myIngredients.count != 0 ?
            CabinetController.shared.myCabinet.sampleIngredients : myIngredients
        CabinetController.shared.saveMyCabinetToUserDefaults()
        let state = ( UserDefaults.standard.object(forKey: TutorialState.myCabinetKey) as? Bool ) ?? true
        self.tutorialState = TutorialState(isActive: state)
        guard let showTutorial = self.tutorialState?.isActive else { return }
        UserDefaults.standard.set(showTutorial, forKey: TutorialState.myCabinetKey)
    }
}
