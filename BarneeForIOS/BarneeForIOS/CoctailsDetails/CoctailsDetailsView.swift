import UIKit

class CoctailsDetailsView: UIViewController {
    private var cocktail: Cocktail

    init(cocktail: Cocktail) {
        self.cocktail = cocktail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Установите фон экрана
        self.view.backgroundColor = UIColor(red: 0x1C / 255.0, green: 0x21 / 255.0, blue: 0x26 / 255.0, alpha: 1.0)

        // Создайте UIImageView для отображения изображения коктеля
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 488)
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true

        if let imageURLString = cocktail.imageURL, let imageURL = URL(string: imageURLString), let imageData = try? Data(contentsOf: imageURL) {
            imageView.image = UIImage(data: imageData)
        }

        view.addSubview(imageView)

        // Создайте UILabel для отображения имени коктеля поверх изображения
        let nameLabel = UILabel()
        nameLabel.frame = CGRect(x: 39, y: 88, width: view.frame.width - 78, height: 50)
        nameLabel.text = cocktail.name
        nameLabel.font = .systemFont(ofSize: 50, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .right
        nameLabel.adjustsFontSizeToFitWidth = true
        view.addSubview(nameLabel)

        // Добавьте другие элементы интерфейса, такие как описание, ингредиенты и инструкции по приготовлению

        // Пример создания описания
        let descriptionLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 20, y: 588, width: view.frame.width - 40, height: 100)
        descriptionLabel.text = "Описание коктеля"
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .white
        view.addSubview(descriptionLabel)

        // Добавьте другие элементы интерфейса, используя данные из вашего коктеля (например, ингредиенты и инструкции)

        // Добавьте изображение кнопки "Favourite" в правом нижнем углу изображения
        let favouriteButton = UIButton()
        let favouriteImage = UIImage(named: "favourite")
        let buttonWidth: CGFloat = 40
        let buttonHeight: CGFloat = 40
        let buttonX = imageView.frame.width - buttonWidth
        let buttonY = imageView.frame.height - buttonHeight
        favouriteButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        favouriteButton.setImage(favouriteImage, for: .normal)
        view.addSubview(favouriteButton)
    }
}
