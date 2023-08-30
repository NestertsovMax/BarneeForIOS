import UIKit

class CoctailsView: UIViewController, CoctailsViewProtocol {
    
    var presenter: CoctailsPresenterProtocol?
    
    private var cocktails: [Cocktail] = []
    private var categories: [String] = []
    private var cocktailNames: [String] = []
    private var viewModelsCategory = [DrinksCategoryCell]()
    
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
        
        presenter = CoctailsPresenter(view: self, interactor: CoctailsInteractor(apiService: APICaller.shared))
        
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
            y: 29,
            width: 64,
            height: 23
        )
        
        drinksCategory.frame = CGRect(
            x: 20,
            y: 78,
            width: 300,
            height: 36
        )
        
        drinksList.frame = CGRect(
            x: 20,
            y: 250,
            width: view.frame.size.width - 10,
            height: view.frame.size.height - 250
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
    
    func reloadCategoryCollectionView() {
        DispatchQueue.main.async {
            self.drinksCategory.reloadData()
        }
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
        flowLayout.itemSize = CGSize(width: itemWidth, height: 200)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
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
        
        let cocktailNames = cocktails.map { $0.name }
        presenter?.updateCategories(cocktailNames)
    }
    
    func updateCategories(_ categories: [String]) {
        self.categories = categories
        reloadCategoryCollectionView()
    }
    
    func showError(_ error: Error) {
        // Handle error presentation
    }

}

protocol CoctailsViewProtocol: AnyObject {
    func updateCocktails(_ cocktails: [Cocktail])
    func showError(_ error: Error)
    func reloadCategoryCollectionView()
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoctailsListCell.identifier, for: indexPath) as! CoctailsListCell
            let cocktail = cocktails[indexPath.row]
            let cocktailName = cocktail.name
            cell.configure(with: cocktailName)
            return cell
        }
    }
}

extension CoctailsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == drinksCategory {
            let selectedCategory = categories[indexPath.item]
        } else if collectionView == drinksList {
            let selectedCocktail = cocktails[indexPath.item]
        }
    }
}


