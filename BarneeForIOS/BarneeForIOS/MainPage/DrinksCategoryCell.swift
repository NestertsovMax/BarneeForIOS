import UIKit

protocol DrinksCategoryCellDelegate: AnyObject {
    func didTapCategory(withId categoryId: Int)
}

class DrinksCategoryCell: UICollectionViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let tasteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var categoryId: Int = 0
    weak var delegate: DrinksCategoryCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setupGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
        setupGestureRecognizer()
    }
    
    private func setupUI() {
        backgroundColor = .blue
        layer.cornerRadius = 8
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(tasteLabel)
        NSLayoutConstraint.activate([
            tasteLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            tasteLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tasteLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            tasteLabel.heightAnchor.constraint(equalToConstant: 18),
            tasteLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapCell))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func didTapCell() {
        delegate?.didTapCategory(withId: categoryId)
    }
    
    func configure(with category: DrinkCategory) {
        categoryId = category.id
        titleLabel.text = category.name
    }
}
