import UIKit
import CloudKit

struct Cocktail: Equatable {
    fileprivate let nameKey = "strDrink"
    fileprivate let instructionsKey = "strInstructions"
    fileprivate let ingredientsKey = "ingredient"
    fileprivate let ingredientProportionsKey = "ingredientProportions"
    fileprivate let imageURLsKey = "strDrinkThumb"
    fileprivate let isAlcoholicKey = "strAlcoholic"
    fileprivate let apiIDKey = "idDrink"
    fileprivate let photoDataKey = "photoData"

    let name: String
    let instructions: String
    let ingredients: [String]
    let ingredientProportions: [String]
    var imageURLs: [String]

    var photoData: Data? {
        guard let tempImage = image,
            let data = tempImage.jpegData(compressionQuality: 1.0)
            else { return nil }
        return data
    }

    var image: UIImage? = nil
    let isAlcoholic: Bool
    var recordID: CKRecord.ID? = nil
    var apiID: String?

    init(name: String, instructions: String, ingredients: [String], ingredientProportions: [String], imageURLs: [String], isAlcoholic: Bool) {
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
        self.ingredientProportions = ingredientProportions
        self.imageURLs = imageURLs
        self.isAlcoholic = isAlcoholic
    }

    //=======================================================
    // MARK: -  CKRecord -> Model Object
    //=======================================================
    // Failable Initializer
    init?(record: CKRecord) {
        guard let name = record["name"] as? String,
            let instructions = record["instructions"] as? String,
            let ingredients = record["ingredients"] as? [String],
            let ingredientProportions = record["ingredientProportions"] as? [String],
            let imageURLs = record["imageURLs"] as? [String],
            let isAlcoholic = record["alcoholic"] as? Bool,
            let apiID = record["apiID"] as? String
            else { return nil }
        if let imageAsset = record["photoData"] as? CKAsset,
            let url = imageAsset.fileURL {
            if let data = try? (Data(contentsOf: url)) {
                let image = UIImage(data: data)
                self.image = image
            }
        }
        self.name = name
        self.instructions = instructions
        self.ingredients = ingredients
        self.ingredientProportions = ingredientProportions
        self.imageURLs = imageURLs
        self.isAlcoholic = isAlcoholic
        self.apiID = apiID
    }

    // Failable Initializer for pulling Cockatils from the API to turn into Model Objects

    init?(cocktailDictionary: [String: Any]) {

        guard let name = cocktailDictionary[nameKey] as? String,
            let instructions = cocktailDictionary[instructionsKey] as? String,
            let alcoholicString = cocktailDictionary[isAlcoholicKey] as? String,
            let apiID = cocktailDictionary[apiIDKey] as? String
            else { return nil }

        var alcoholicBool: Bool = false

        switch alcoholicString {
        case "Alcoholic":
            alcoholicBool = true
        case "Non_Alcoholic":
            alcoholicBool = false
        default:
            break
        }

        var ingredientsStrings: [String] = []
        var measurementStrings: [String] = []

        for n in 1...15 {
            guard let ingredientString = cocktailDictionary["strIngredient\(n)"] as? String,
                let measurementString = cocktailDictionary["strMeasure\(n)"] as? String,
                ingredientString != "",
                measurementString != ""
                else { break }

            ingredientsStrings.append(ingredientString)
            measurementStrings.append(measurementString)
        }

        let imageURL = cocktailDictionary[imageURLsKey] as? String ?? ""
        var imageURLStrings: [String] = []
        imageURLStrings.append(imageURL)

        self.name = name
        self.instructions = instructions
        self.ingredients = ingredientsStrings
        self.ingredientProportions = measurementStrings
        self.imageURLs = imageURLStrings
        self.isAlcoholic = alcoholicBool
        self.apiID = apiID

    }

    fileprivate var temporaryPhotoURL: URL {
        // Must write to temporary directory to be able to pass image file path url to CKAsset
        let temporaryDirectory = NSTemporaryDirectory()
        let temporaryDirectoryURL = URL(fileURLWithPath: temporaryDirectory)
        let fileURL = temporaryDirectoryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("png")

        try? photoData?.write(to: fileURL, options: [.atomic])
        print(fileURL)
        return fileURL
    }
}

//=======================================================
// MARK: - Model Object -> CKRecord
//=======================================================
extension CKRecord {
    convenience init(cocktail: Cocktail) {
        let recordID = cocktail.recordID ?? CKRecord.ID(recordName: UUID().uuidString)
        self.init(recordType: "Cocktail", recordID: recordID)
        self.setValue(cocktail.name, forKey: "name")
        self.setValue(cocktail.instructions, forKey: "instructions")
        self.setValue(cocktail.ingredients, forKey: "ingredients")
        self.setValue(cocktail.ingredientProportions, forKey: "ingredientProportions")
        self.setValue(cocktail.imageURLs, forKey: "imageURLs")
        self.setValue(cocktail.isAlcoholic, forKey: "alcoholic")
        self.setValue(cocktail.apiID, forKey: "apiID")

        if cocktail.image != nil {
            let asset = CKAsset(fileURL: cocktail.temporaryPhotoURL)
            self["photoData"] = asset
        }
    }

}

extension Cocktail {
    static func ==(lhs: Cocktail, rhs: Cocktail) -> Bool {
        return lhs.name == rhs.name
    }
}
