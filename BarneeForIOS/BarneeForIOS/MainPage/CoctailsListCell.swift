//
//  CoctailsListCell.swift
//  BarneeForIOS
//
//  Created by M1 on 01.08.2023.
//

import UIKit
import Foundation

class CoctailsListCell: UICollectionViewCell {
    static let identifier = "CoctailsListCell"
    
    private let cocktailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cocktailImageView)
        contentView.addSubview(nameLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        
        cocktailImageView.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.width, height: contentView.frame.size.height - 40)
        nameLabel.frame = CGRect(x: 0, y: contentView.frame.size.height - 40, width: contentView.frame.size.width, height: 40)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cocktailImageView.image = nil
        nameLabel.text = nil
    }
    
    func configure(with cocktail: Cocktail) {
        nameLabel.text = cocktail.name
        if let url = URL(string: cocktail.imageURL ?? "") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async { [weak self] in
                        self?.cocktailImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
}
