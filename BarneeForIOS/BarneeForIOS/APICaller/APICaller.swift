import Foundation

protocol APICallerProtocol {
    func getCocktails(completion: @escaping (Result<Data, Error>) -> Void)
}

class APICaller: APICallerProtocol {
    
    static let shared = APICaller()
    private init() {}

    func getCocktails(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = Constants.drinksURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                completion(.success(data))
            } else {
                let error = NSError(domain: "com.yourapp.api", code: 0, userInfo: [NSLocalizedDescriptionKey: "Данные не получены"])
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}

extension APICaller {
    struct Constants {
        static let drinksURL = URL(string: "https://api.absolutdrinks.com/drinks/all")
    }
}

struct ImageInfo: Codable {
    let uri: String
}

struct Cocktail: Codable {
    let id: String
    let name: String
    var imageURL: String
    let recipeID: String
    let images: [ImageInfo]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case images = "images"
        case recipeID = "recipeId"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        images = try container.decode([ImageInfo].self, forKey: .images)
        recipeID = try container.decode(String.self, forKey: .recipeID)

        if let firstImage = images.first {
            imageURL = firstImage.uri
        } else {
            imageURL = ""
        }
    }
}
