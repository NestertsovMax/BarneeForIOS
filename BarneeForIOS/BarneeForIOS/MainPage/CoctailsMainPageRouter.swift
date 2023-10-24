//
//  CoctailsMainPageRouter.swift
//  BarneeForIOS
//
//  Created by M1 on 30.08.2023.
//

import Foundation
import UIKit

class CoctailsMainPageRouter {
    weak var viewController: UIViewController?
    
    func openCoctailDetails(coctail: Cocktail) {
        let coctailDetailsViewController = CoctailsDetailsView(cocktail: coctail)
        let presenter = CoctailsDetailsPresenter(coctail: coctail)
        presenter.viewController = coctailDetailsViewController
        viewController?.present(coctailDetailsViewController, animated: true)
    }
}
