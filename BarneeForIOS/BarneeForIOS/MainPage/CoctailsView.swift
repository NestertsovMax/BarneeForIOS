import UIKit

class CoctailsView: UIViewController, CoctailsViewProtocol {
    var presenter: CoctailsPresenterProtocol?
    
    private var cocktails: [Cocktail] = []
    private var categories: [String] = []
    private var cocktailNames: [String] = []
    private var viewModelsCategory = [DrinksCategoryCell]()
    private var currentPage = 1
    private let cocktailsPerPage = 10
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let drinksCategory: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DrinksCategoryCell.self, forCellWithReuseIdentifier: DrinksCategoryCell.identifier)
        return collectionView
    }()
    
    private let drinksList: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(CoctailsListCell.self, forCellWithReuseIdentifier: CoctailsListCell.identifier)
        return collectionView
    }()
    
    private let filtersPanel: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layer.cornerRadius = 12
        stackView.clipsToBounds = true
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundColor = UIColor(
            red: CGFloat(0x1C) / 255.0,
            green: CGFloat(0x21) / 255.0,
            blue: CGFloat(0x26) / 255.0,
            alpha: 1.0
        )
        
        setCommonBackgroundColor(backgroundColor)
        setupHorizontalCollectionView()
        setupVerticalCollectionView()
        setupStackView()
        
        
        self.view.addSubview(logoLabel)
        self.view.addSubview(drinksCategory)
        self.view.addSubview(drinksList)
        self.view.addSubview(filtersPanel)
        
        drinksCategory.delegate = self
        drinksCategory.dataSource = self
        drinksList.delegate = self
        drinksList.dataSource = self
        
        presenter?.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        logoLabel.frame = CGRect(
            x: 20,
            y: 35,
            width: 64,
            height: 23
        )
        
        drinksCategory.frame = CGRect(
            x: 20,
            y: 78,
            width: 300,
            height: 36
        )
        
        let drinksListY: CGFloat = 250
        let drinksListHeight = view.frame.size.height - drinksListY - 20
        
        drinksList.frame = CGRect(
            x: 20,
            y: drinksListY,
            width: view.frame.size.width - 40,
            height: drinksListHeight
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        logoLabel.text = "Barnee"
        logoLabel.font = .systemFont(ofSize: 20)
        logoLabel.textColor = UIColor(
            red: CGFloat(0x5C) / 255.0,
            green: CGFloat(0x5D) / 255.0,
            blue: CGFloat(0x5F) / 255.0,
            alpha: 1.0)
    }
    
    func setCommonBackgroundColor(_ color: UIColor) {
        view.backgroundColor = color
        logoLabel.backgroundColor = color
        drinksCategory.backgroundColor = .blue
        drinksList.backgroundColor = color
    }
    
    func setupHorizontalCollectionView() {
        let horizontalLayout = UICollectionViewFlowLayout()
        horizontalLayout.scrollDirection = .horizontal
        horizontalLayout.itemSize = CGSize(width: 100, height: 36)
        drinksCategory.collectionViewLayout = horizontalLayout
    }
    
    func setupVerticalCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let itemWidth = (drinksList.bounds.width - flowLayout.minimumInteritemSpacing) / 2
        let itemHeight: CGFloat = 250 // Оставьте высоту ячейки без изменений
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.minimumLineSpacing = 20
        drinksList.collectionViewLayout = flowLayout
    }



    
    func setupStackView() {
        view.addSubview(filtersPanel)
        
        NSLayoutConstraint.activate([
            filtersPanel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            filtersPanel.widthAnchor.constraint(equalToConstant: 366),
            filtersPanel.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        let favourite = UIButton()
        let filters = UIButton()
        let search = UIButton()
        
        favourite.setImage(UIImage(named: "favourite"), for: .normal)
        filters.setImage(UIImage(named: "filters"), for: .normal)
        search.setImage(UIImage(named: "search"), for: .normal)
        
        favourite.contentMode = .scaleToFill
        
        filtersPanel.addArrangedSubview(favourite)
        filtersPanel.addArrangedSubview(filters)
        filtersPanel.addArrangedSubview(search)
        
        filtersPanel.backgroundColor = UIColor(
            red: CGFloat(0x56) / 255.0,
            green: CGFloat(0x56) / 255.0,
            blue: CGFloat(0x56) / 255.0,
            alpha: 1.0
        )
    }

    func updateCocktails(_ cocktails: [Cocktail]) {
        self.cocktails = cocktails
        self.drinksList.reloadData()
        self.drinksCategory.reloadData()
    }
    
    func updateCategories(_ categories: [String]) {
        self.categories = categories
        self.drinksCategory.reloadData()
    }
    
    func showError(_ error: Error) {
    }

}

protocol CoctailsViewProtocol: AnyObject {
    func updateCocktails(_ cocktails: [Cocktail])
    func showError(_ error: Error)
    func updateCategories(_ categories: [String])
}

extension CoctailsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == drinksCategory {
            return categories.count
        } else if collectionView == drinksList {
            return cocktails.count
        }
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == drinksCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinksCategoryCell", for: indexPath) as! DrinksCategoryCell
            cell.configure(with: categories[indexPath.row])
            return cell
        } else if collectionView == drinksList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoctailsListCell", for: indexPath) as! CoctailsListCell
            let cocktail = cocktails[indexPath.row]
            cell.configure(with: cocktail)
            return cell
        }
        return UICollectionViewCell()
    }



}

extension CoctailsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == drinksCategory {
            presenter?.didSelectCategory(at: indexPath.row)
        } else if collectionView == drinksList {
            presenter?.didSelectCocktail(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == drinksList && indexPath.row == cocktails.count {
            
        }
    }

}

extension CoctailsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == drinksList {
            // Рассчитайте ширину ячейки так, чтобы у вас было два столбца с отступами между ними
            let numberOfColumns: CGFloat = 2
            let spacingBetweenColumns: CGFloat = 20
            let totalSpacing = (numberOfColumns - 1) * spacingBetweenColumns
            let itemWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
            let itemHeight: CGFloat = 224 // Оставьте высоту ячейки без изменений
            return CGSize(width: itemWidth, height: itemHeight)
        }
        return CGSize(width: 0, height: 0) // Возвращайте нулевой размер для других коллекций
    }
}



