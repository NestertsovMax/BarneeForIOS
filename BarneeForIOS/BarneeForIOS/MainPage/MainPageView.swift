//
//  mainPageView.swift
//  BarneeForIOS
//
//  Created by M1 on 19.06.2023.
//

import UIKit

class MainPageViewController: UIViewController {
    
    private var logoLabel: UILabel {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }
    
    private var drinksCategory: UICollectionView {
        let collectionView = UICollectionView()
        //collectionView.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
        return collectionView
    }
    
    private var drinksList: UICollectionView {
        let collectionView = UICollectionView()
        //collectionView.register(<#T##nib: UINib?##UINib?#>, forCellWithReuseIdentifier: <#T##String#>)
        return collectionView
    }
    
    private var filters: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.spacing = .greatestFiniteMagnitude
        return stackView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkGray

        self.view.addSubview(logoLabel)
        self.view.addSubview(drinksCategory)
        self.view.addSubview(drinksList)
        self.view.addSubview(filters)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoLabel.frame = CGRect(
            x: 20,
            y: 100,
            width: view.frame.self.width - 10,
            height: 70
        )
        
        drinksCategory.frame = CGRect(
            x: 20,
            y: 200,
            width: 300,
            height: 100
        )
        
        drinksList.frame = CGRect(
            x: 20,
            y: 250,
            width: view.frame.self.width - 10,
            height: view.frame.self.height
        )
        
        filters.frame = CGRect(
            x: 20,
            y: 400,
            width: 300,
            height: 50
        )
    }

}

extension MainPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        <#code#>
    }
}

extension MainPageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    
}
