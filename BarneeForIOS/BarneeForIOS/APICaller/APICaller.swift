import Foundation
import OSLog

protocol APICallerProtocol {
    func getCocktails(page: Int, completion: @escaping (Result<Data, Error>) -> Void)
}

class APICaller: APICallerProtocol {
  
    
    
    static let shared = APICaller()
    private init() {}

    func getCocktails(page: Int, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = Constants.drinksURL else {
            return
    }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let data = data {
                let info = String(data: data, encoding: .utf8)!
                Logger(subsystem: "Max", category: "Max").info("\(info)")
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

struct ResultContainer<T: Codable>: Codable {
    let result: [T]
}

struct ImageInfo: Codable {
    let uri: String
}

struct Cocktail: Codable {
    let id: String
    let name: String
    var imageURL: String?
    let recipeID: String?
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
        images = try container.decodeIfPresent([ImageInfo].self, forKey: .images) ?? []
        recipeID = try container.decodeIfPresent(String.self, forKey: .recipeID) ?? ""
        imageURL = images.first?.uri
    }
    
    
}
