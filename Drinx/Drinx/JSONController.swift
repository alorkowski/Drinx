import Foundation

class JSONController {
    static let shared = JSONController()
    
    func getCocktailDictionaryArray() -> [[String:Any]]? {
        guard let path = Bundle.main.path(forResource: "CocktailRecipes", ofType: "json") else { return nil }
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            guard let jsonArray = try JSONSerialization.jsonObject(with: data,
                                                                   options: .allowFragments) as? [[String: Any]]
                else { return nil}
            return jsonArray
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
