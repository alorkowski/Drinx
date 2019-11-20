import UIKit

protocol TutorialDelegate {
    func showTutorial(viewController: UIViewController,
                      title: String,
                      message: String,
                      alertActionTitle: String,
                      completion: @escaping () -> Void)
}

extension TutorialDelegate {
    func showTutorial(viewController: UIViewController,
                      title: String,
                      message: String,
                      alertActionTitle: String,
                      completion: @escaping () -> Void) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let showMeTheNextTab = UIAlertAction(title: alertActionTitle,
                                             style: .cancel) { (_) in completion() }
        alert.addAction(showMeTheNextTab)
        viewController.present(alert, animated: true)
    }
}
