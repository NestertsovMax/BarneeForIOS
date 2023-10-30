import Foundation

protocol CoctailsInteractorProtocol {
    func fetchCocktails(page: Int)
}
protocol APICallerDelegate: AnyObject {
    func didReceiveCocktails(_ cocktails: [Cocktail])
}
protocol CoctailsInteractorDelegate: AnyObject {
    func didReceiveCocktails(_ cocktails: [Cocktail])
    func didReceiveError(_ error: Error)
}

class CoctailsInteractor: CoctailsInteractorProtocol {
    
    private let apiService: APICallerProtocol
    private var cocktails: [Cocktail] = []
    
    
    weak var delegate: CoctailsInteractorDelegate?
    
    init(apiService: APICallerProtocol) {
        self.apiService = apiService
    }
    
    func fetchCocktails(page: Int) {
        apiService.getCocktails(page: 1) { result in
            switch result {
            case .success(let data):
                do {
                    let cocktailsResult = try JSONDecoder().decode(ResultContainer<Cocktail>.self, from: data)
                    self.cocktails = cocktailsResult.result
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveCocktails(self.cocktails)
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.delegate?.didReceiveError(error)
                    }
                }
                
            case .failure(let error):
                self.delegate?.didReceiveError(error)
            }
        }
    }
}

extension CoctailsInteractor: APICallerDelegate {
    func didReceiveCocktails(_ cocktails: [Cocktail]) {
        delegate?.didReceiveCocktails(cocktails)
    }
}
