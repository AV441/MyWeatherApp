//
//  CollectionHeaderView.swift
//  MyWeatherApp
//
//  Created by Андрей on 14.11.2022.
//

import UIKit

final class CollectionHeaderView: UICollectionReusableView {

    static let identifier = "CollectionHeaderView"
    static let nib = UINib(nibName: "CollectionHeaderView", bundle: nil)
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setHeader(ofType header: SectionHeaderType) {
        label.text = header.rawValue
        imageView.image = ImageGenerator.headerImage(for: header)
    }
}
