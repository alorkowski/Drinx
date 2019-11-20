import UIKit

struct Cocktail: Decodable, Equatable {
    let name: String
    let instructions: String
    let ingredients: [String]
    let ingredientProportions: [String]
    var imageURLs: [String]
    let isAlcoholic: Bool
    var apiID: String?

    var photoData: Data? {
        guard let tempImage = image,
            let data = tempImage.jpegData(compressionQuality: 1.0)
            else { return nil }
        return data
    }

    var image: UIImage? = nil

    fileprivate enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case instructions = "strInstructions"
        case ingredients = "ingredient"
        case ingredientProportions = "ingredientProportions"
        case imageURLs = "strDrinkThumb"
        case isAlcoholic = "strAlcoholic"
        case apiID = "idDrink"
    }

    init(name: String,
         instructions: String,
         ingredients: [String],
         ingredientProportions: [String],
         imageURLs: [String],
         isAlcoholic: Bool,
         apiID: String) {
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
        guard let name = cocktailDictionary[CodingKeys.name.rawValue] as? String,
            let instructions = cocktailDictionary[CodingKeys.instructions.rawValue] as? String,
            let alcoholicString = cocktailDictionary[CodingKeys.isAlcoholic.rawValue] as? String,
            let apiID = cocktailDictionary[CodingKeys.apiID.rawValue] as? String
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

        let imageURL = cocktailDictionary[CodingKeys.imageURLs.rawValue] as? String ?? ""
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
}

extension Cocktail {
    static func ==(lhs: Cocktail, rhs: Cocktail) -> Bool {
        return lhs.name == rhs.name
    }
}
