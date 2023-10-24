//
//  CoctailsDetailsPresenter.swift
//  BarneeForIOS
//
//  Created by M1 on 30.08.2023.
//

import Foundation
import UIKit

class CoctailsDetailsPresenter {
    private let coctail: Cocktail
    weak var viewController: UIViewController?
    
    
    init(coctail: Cocktail) {
        self.coctail = coctail
    }
}
