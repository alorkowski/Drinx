import UIKit

public protocol NibRepresentedView {
    static var identifier: String { get }
    static var bundle: Bundle? { get }
}

public extension NibRepresentedView where Self: UIView {
    static var identifier: String {
        return String(describing: Self.self)
    }

    static var bundle: Bundle? {
        return Bundle(for: Self.self)
    }
}

public extension NibRepresentedView where Self: UITableViewCell {
    static func register(with tableView: UITableView) {
        tableView.register(UINib(nibName: Self.identifier, bundle: bundle),
                           forCellReuseIdentifier: Self.identifier)
    }

    static func dequeue(from tableView: UITableView) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: Self.identifier) as! Self
    }

    static func dequeue(from tableView: UITableView, for indexPath: IndexPath) -> Self {
        return tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as! Self
    }
}
