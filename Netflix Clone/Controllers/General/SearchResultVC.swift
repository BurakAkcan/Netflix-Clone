//
//  SearchResultVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 12.09.2022.
//

import UIKit
protocol SearchResultVCDelegate:AnyObject{
    func searchResultVCDidTapped(_ viewModel:MoviePreviewViewModel)
}

class SearchResultVC: UIViewController {
    
    public var movieList:Movies = []
    public weak var delegate:SearchResultVCDelegate?
    
    public let searchResultCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10 , height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        return collection
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(searchResultCollectionView)
        searchResultCollectionView.delegate = self
        searchResultCollectionView.dataSource = self
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultCollectionView.frame = view.bounds
    }
    

}

extension SearchResultVC:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as? MovieCollectionCell else{
            return UICollectionViewCell()
        }
        let item = movieList[indexPath.item]
        cell.configure(with: item.poster_path ?? "")
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movieList[indexPath.row]
        let movieName = movie.original_title ??  ""
        
        APICaller.shared.getMovie(with: movieName) { [weak self] result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let element):
                self?.delegate?.searchResultVCDidTapped(MoviePreviewViewModel(title: movie.original_title ?? movie.original_name ?? "", youtubeView: element, movieOverView: movie.overview ?? "Unknown"))
                
            }
        }
        
        
    }
}
