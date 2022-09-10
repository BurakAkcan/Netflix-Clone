//
//  HeroHeaderView.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

class HeroHeaderView: UIView {
    
    private let downloadButton:UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton:UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ic_better")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
    }
    
   private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -20),
            playButton.widthAnchor.constraint(equalToConstant: 100)
            ]
       let downloadButtonConstraints = [
        downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -70),
        downloadButton.bottomAnchor.constraint(equalTo: playButton.bottomAnchor),
        downloadButton.widthAnchor.constraint(equalTo: playButton.widthAnchor)
       ]
       
       NSLayoutConstraint.activate(playButtonConstraints)
       NSLayoutConstraint.activate(downloadButtonConstraints)
       
    }
    
    
    
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemGray.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
    
}
