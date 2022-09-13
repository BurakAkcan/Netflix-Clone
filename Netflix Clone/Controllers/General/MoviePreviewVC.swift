//
//  MoviePreviewVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 13.09.2022.
//

import UIKit
import WebKit

class MoviePreviewVC: UIViewController {
    
    private let movieLabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Harry Potter" // Değişcek
        return label
    }()
    
    private let overViewLabel:UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.lineBreakMode = .byTruncatingTail
        label.minimumScaleFactor = 0.6
        label.text = "This is the best movie"
        return label
    }()
    
    private let downloadButton:UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
        button.setTitle("Download", for: .normal)
        button.layer.cornerRadius = 16
        button.layer.shadowColor = UIColor.systemGray.cgColor
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 1
        button.layer.masksToBounds = false
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    private let webView:WKWebView = {
       let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        #warning("renk systembackground olacak")
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .label
        configureSubviews()
        configureUI()
        

    }
   
    
    func configureSubviews(){
        view.addSubview(webView)
        view.addSubview(overViewLabel)
        view.addSubview(downloadButton)
        view.addSubview(movieLabel)
        
    }
    
    private func configureUI(){
        NSLayoutConstraint.activate([
            //Set webView UI
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300),
            
            //Set movieNameLabel UI
            
            movieLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            movieLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            //Set overViewLabel UI
            
            overViewLabel.topAnchor.constraint(equalTo: movieLabel.bottomAnchor, constant: 15),
            overViewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            overViewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
            //Set downLoadButton UI
            
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            downloadButton.topAnchor.constraint(equalTo: overViewLabel.bottomAnchor,constant: 20),
            downloadButton.widthAnchor.constraint(equalToConstant: 140),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
            
            ])
    }
    
    
    func configure(with model:MoviePreviewViewModel){
        movieLabel.text = model.title
        overViewLabel.text = model.movieOverView
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else{return}
        webView.load(URLRequest(url: url))
    }
    
    

}
