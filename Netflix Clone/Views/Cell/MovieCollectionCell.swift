//
//  MovieCollectionCell.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 11.09.2022.
//

import UIKit
import SDWebImage
import Kingfisher

class MovieCollectionCell: UICollectionViewCell {
    static let identifier = "MovieCollectionCell"
    
    private let poserImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(poserImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        poserImageView.frame = contentView.bounds
    }
    
    public func configure(with model:String){
       
       
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else{return}
      
        poserImageView.kf.setImage(with: url)
    }
    
    
    
    
    
}
