import UIKit
import Foundation

protocol CoctailsPresenterProtocol {
    func viewDidLoad()
    func didSelectCategory(at name: String)
    func didSelectCocktail(at index: Int)
    func didTapFilterButton()
}

class CoctailsPresenter: CoctailsPresenterProtocol {
    
    private weak var view: CoctailsViewProtocol?
    let interactor: CoctailsInteractor
    let router: CoctailsMainPageRouter
    weak var delegate: DrinksCategoryCellDelegate?
    private var cocktails: [Cocktail] = []
    private var randomCocktailNames: [String] = []
    
    private var currentPage = 1
    init(view: CoctailsViewProtocol, interactor: CoctailsInteractorProtocol, router: CoctailsMainPageRouter) {
        self.view = view
        self.interactor = interactor as! CoctailsInteractor
        self.router = router
    }
    func viewDidLoad() {
        interactor.fetchCocktails(page: currentPage)
    }
    
    func didSelectCategory(at name: String) {
        if let selectedCocktail = cocktails.first(where: { $0.name == name }) {
            router.openCoctailDetails(coctail: selectedCocktail)
        }
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

        var cocktailNames = cocktails.map { $0.name }
        view?.updateCategories(cocktailNames)

        let randomCocktailNames = getRandomCocktailNames()
        view?.updateCategories(randomCocktailNames)
    }
    
    func getRandomCocktailNames() -> [String] {
        let randomCocktails = cocktails.shuffled().prefix(10)
        return randomCocktails.map { $0.name }
    }
    
    func didTapCategory(at name: String) {
        if let cocktail = cocktails.first(where: { $0.name == name }) {
            router.openCoctailDetails(coctail: cocktail)
        }
    }
}
