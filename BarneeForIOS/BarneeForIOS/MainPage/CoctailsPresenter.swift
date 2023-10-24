import UIKit
import Foundation

protocol CoctailsPresenterProtocol {
    func viewDidLoad()
    func didSelectCategory(at index: Int)
    func didSelectCocktail(at index: Int)
    func didTapFilterButton()
}

class CoctailsPresenter: CoctailsPresenterProtocol {
    private weak var view: CoctailsViewProtocol?
    let interactor: CoctailsInteractor
    let router: CoctailsMainPageRouter
    
    private var cocktails: [Cocktail] = []
    
    private var cocktailNames: [String] = []
    private var currentPage = 1
    init(view: CoctailsViewProtocol, interactor: CoctailsInteractorProtocol, router: CoctailsMainPageRouter) {
        self.view = view
        self.interactor = interactor as! CoctailsInteractor
        self.router = router
    }
    func viewDidLoad() {
        interactor.fetchCocktails(page: currentPage)
        fetchRandomCocktails(count: 6)
    }
    
    func fetchRandomCocktails(count: Int) {
        let randomCocktails = cocktails.shuffled().prefix(count)
        view?.updateCocktails(Array(randomCocktails))
    }

    
    func didSelectCategory(at index: Int) {
        
    }
    
    func didSelectCocktail(at index: Int) {
        let coctail = cocktails[index]
        router.openCoctailDetails(coctail: coctail)
    }
    
    func didTapFilterButton() {
    }
}

extension CoctailsPresenter: CoctailsInteractorDelegate {
    func didReceiveError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(okAction)
            if let viewController = self?.view as? UIViewController {
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func didReceiveCocktails(_ cocktails: [Cocktail]) {
        self.cocktails = cocktails
        view?.updateCocktails(cocktails)
        
        cocktailNames = cocktails.map { $0.name }
        view?.updateCategories(cocktailNames)
    }
}
