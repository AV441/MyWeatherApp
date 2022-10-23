//
//  BackgroundDecorationView.swift
//  MyWeatherApp
//
//  Created by Андрей on 31.05.2022.
//

import UIKit

class BackgroundDecorationView: UICollectionReusableView {
    
    private var decorationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 140/255, alpha: 0.7)
        view.layer.borderWidth = 0.2
        view.layer.cornerRadius = 15
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(decorationView)
        
        NSLayoutConstraint.activate([
            decorationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: decorationView.trailingAnchor),
            decorationView.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: decorationView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
