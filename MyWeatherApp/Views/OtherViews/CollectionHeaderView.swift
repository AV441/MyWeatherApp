//
//  CollectionHeaderView.swift
//  MyWeatherApp
//
//  Created by Андрей on 14.11.2022.
//

import UIKit

final class CollectionHeaderView: UICollectionReusableView {

    public static let identifier = "CollectionHeaderView"
    public static let nib = UINib(nibName: "CollectionHeaderView", bundle: nil)
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setHeader(ofType header: SectionHeaderType) {
        label.text = header.rawValue
        imageView.image = header.image
    }
}
