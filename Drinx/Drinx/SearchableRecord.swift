import Foundation

protocol SearchableRecord {
    func matches(searchTerm: String) -> Bool
}
