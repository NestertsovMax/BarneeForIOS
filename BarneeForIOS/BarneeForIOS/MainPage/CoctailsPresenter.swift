import UIKit
import Foundation

protocol CoctailsPresenterProtocol {
    func viewDidLoad()
    func didSelectCategory(at index: Int)
    func didSelectCocktail(at index: Int)
    func didTapFilterButton()
    func updateCategories(_ categories: [String])
}

class CoctailsPresenter: CoctailsPresenterProtocol {
    private weak var view: CoctailsViewProtocol?
    let interactor: CoctailsInteractor
    
    private var cocktails: [Cocktail] = []
    
    private var cocktailNames: [String] = []
    init(view: CoctailsViewProtocol, interactor: CoctailsInteractorProtocol) {
        self.view = view
        self.interactor = interactor as! CoctailsInteractor
    }
    func viewDidLoad() {
        interactor.fetchCocktails()
    }
    
    func didSelectCategory(at index: Int) {
    }
    
    func didSelectCocktail(at index: Int) {
    }
    
    func didTapFilterButton() {
    }
    
    func updateCategories(_ categories: [String]) {
        cocktailNames = categories
        view?.reloadCategoryCollectionView()
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
        updateCategories(cocktailNames)
    }
}
