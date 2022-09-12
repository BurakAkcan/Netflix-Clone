//
//  UpComingTableCell.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 12.09.2022.
//

import UIKit
import SDWebImage
import Kingfisher


class UpComingTableCell: UITableViewCell {
    
    static let identifer = "UpComingTableCell"
    
    private let titleLabel:UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.6
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let playButton:UIButton = {
        let button = UIButton()
        //Buton içerindeki image size ayarlama
        let image = UIImage(systemName: "play.circle",withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        return button
    }()
    
    private let posterImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //Set cells between space
    override func layoutSubviews() {
        super.layoutSubviews()
        let bottomSpace: CGFloat = 8.0 // Let's assume the space you want is 10
              self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: bottomSpace, right: 0))
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playButton)
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            //Set PosterImageView
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            //Set titleLabel
            titleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor,constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60),
            
            //Set button
            
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           
            
            
            
        ])
        playButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        
        
        
        
        
    }
    
    public func configure(with model:MovieViewModel){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterUrl)") else{
            
            return}
        posterImageView.kf.setImage(with: url)
        titleLabel.text = model.titleName
    }
    
    

 
}
