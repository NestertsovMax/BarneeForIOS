import UIKit

class CoctailsView: UIViewController {
    
    private var drinksCategories: [DrinkCategory] = []
    private var tastes: [String] = []
    private var cocktails: [Cocktail] = []
    
    private let logoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let drinksCategory: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(DrinksCategoryCell.self, forCellWithReuseIdentifier: "DrinksCategoryCell")
        return collectionView
    }()

    
    private let drinksList: UICollectionView = {
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(CoctailsListCell.self, forCellWithReuseIdentifier: "CoctailsListCell")
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
        fetchDrinkCategories()
        fetchTastes()
        
        self.view.addSubview(logoLabel)
        self.view.addSubview(drinksCategory)
        self.view.addSubview(drinksList)
        self.view.addSubview(filtersPanel)
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
            width: view.frame.self.width - 10,
            height: 36
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
    
    func fetchDrinkCategories() {
            guard let url = URL(string: "https://api.absolutdrinks.com/drinks/tasting") else {
                return
            }
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self, let data = data else {
                    return
                }
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        let categories = jsonArray.compactMap { DrinkCategory(json: $0) }
                        self.drinksCategories = categories
                        DispatchQueue.main.async {
                            self.drinksCategory.reloadData()
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }.resume()
        }
    
    func fetchTastes() {
            guard let url = URL(string: "https://api.absolutdrinks.com/drinks/taste") else {
                return
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self, let data = data else {
                    return
                }
                
                do {
                    if let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] {
                        let tastes = jsonArray.compactMap { tasteData in
                            tasteData["name"] as? String
                        }
                        self.tastes = tastes
                        DispatchQueue.main.async {
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            }.resume()
        }
}

extension CoctailsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == drinksCategory {
            return drinksCategories.count
        } else {
            return cocktails.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == drinksCategory {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DrinksCategoryCell", for: indexPath) as! DrinksCategoryCell
            let category = drinksCategories[indexPath.item]
            cell.configure(with: category)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoctailsListCell.identifier, for: indexPath) as! CoctailsListCell
            let cocktail = cocktails[indexPath.item] // Подставьте правильные данные для коктейлей из вашей модели
            cell.configure(with: cocktail)
            return cell
        }
    }
}

extension CoctailsView: UICollectionViewDelegate {
}


struct DrinkCategory {
    let id: Int
    let name: String

    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
              let name = json["name"] as? String else {
            return nil
        }

        self.id = id
        self.name = name
    }
}

struct Cocktail {
    let id: String
    let name: String
    let imageUrl: String
    
    init?(json: [String: Any]) {
        guard let id = json["idDrink"] as? String,
              let name = json["strDrink"] as? String,
              let imageUrl = json["strDrinkThumb"] as? String else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }
}
