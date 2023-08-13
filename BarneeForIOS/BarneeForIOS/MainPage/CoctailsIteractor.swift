import Foundation

protocol CoctailsInteractorProtocol {
    func fetchCocktails()
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
    
    func fetchCocktails() {
        apiService.getCocktails { result in
            switch result {
            case .success(let data):
                do {
                    let cocktails = try JSONDecoder().decode([Cocktail].self, from: data)
                    self.cocktails = cocktails
                    self.delegate?.didReceiveCocktails(cocktails)
                } catch {
                    self.delegate?.didReceiveError(error)
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
