//
//  HeaderView.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"
    
    let stackView: UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .horizontal
        StackView.distribution = .fill
        StackView.alignment = .leading
        StackView.spacing = 4
        StackView.translatesAutoresizingMaskIntoConstraints = false
        return StackView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    
    let separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.5)
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        addSubview(stackView)
        addSubview(separator)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 8),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            
            separator.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 0),
            separator.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: 0),
            separator.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(with title: String, and image: UIImage?) {
        label.text = title
        guard let image = image else { return }
        imageView.image = image
    }
}
