import UIKit
import CloudKit

final class ImageController {
    static func getImage(forURL url: String,
                         completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url) else { completion(nil); return }
        NetworkController.performRequest(forURL: url, httpMethod: .get) { (data, error) in
            if let error = error {
                print("Error performing network request: \(error.localizedDescription)")
            }
            guard let data = data,
                let image = UIImage(data: data) else {
                    DispatchQueue.main.async { completion(nil) }
                    return
            }
            DispatchQueue.main.async { completion(image) }
        }
    }
    
    // MARK: - Get Images For Cocktails With Images
    static func fetchAvailableImagesFromCloudKit(forCocktails cocktails: [Cocktail],
                                                 perRecordCompletion: @escaping (Cocktail?) -> Void) {
        var cocktailsWithImagesOnCloudKit: [Cocktail] = []
        var apiIDsOfCocktailsWithImages: [String] = []
        for cocktail in cocktails {
            if cocktail.imageURLs[0] != "" {
                cocktailsWithImagesOnCloudKit.append(cocktail)
                if let apiID = cocktail.apiID {
                    apiIDsOfCocktailsWithImages.append(apiID)
                }
            }
        }
        for apiID in apiIDsOfCocktailsWithImages {
            let predicate = NSPredicate(format: "%@ = apiID", apiID)
            let query = CKQuery(recordType: "Cocktail", predicate: predicate)
            let queryOperation = CKQueryOperation(query: query)
            queryOperation.recordFetchedBlock = { (record) -> Void in
                let tempCocktail = Cocktail(record: record)
                perRecordCompletion(tempCocktail)
            }
            queryOperation.queryCompletionBlock = { (cursor, error) -> Void in
                
            }
            CloudKitManager.shared.publicDatabase.add(queryOperation)
        }
    }
}
