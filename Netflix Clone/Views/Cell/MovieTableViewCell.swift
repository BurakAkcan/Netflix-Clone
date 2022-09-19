//
//  CollectionViewTableCell.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

protocol MovieTableViewCellDelegate:AnyObject{
    func MovieTableViewCellDidTapCell(_ cell:MovieTableViewCell,viewModel:MoviePreviewViewModel)
}

class MovieTableViewCell: UITableViewCell {

   static let identifier = "MovieTableViewCell"
    
    private var movies:Movies = []
    weak var delegate:MovieTableViewCellDelegate?
    
    private let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MovieCollectionCell.self, forCellWithReuseIdentifier: MovieCollectionCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    public func configure(with movieList:Movies){
        self.movies = movieList
        DispatchQueue.main.async { [weak self] in
            guard let self = self else{return}
            self.collectionView.reloadData()
            
        }
    }
    
    private func downloadMovieAt(indexPath:IndexPath){
        DataPersistanceManager.shared.downloadMovie(model: movies[indexPath.row]) { [weak self] result in
            guard let self = self else{return}
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success():
                print("Succes download database ")
            }
        }
        
    }
    
    
}

//MARK: - Extensions
extension MovieTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionCell.identifier, for: indexPath) as? MovieCollectionCell else {return UICollectionViewCell()}
        guard let poster = movies[indexPath.row].poster_path else{return UICollectionViewCell()}
        cell.configure(with: poster)
        #warning("configure düzeltilecek")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name else{return}
        
        APICaller.shared.getMovie(with: movieName + "trailer") {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .failure(let error):
                print(error)
            case .success(let element):
                print(element.id)
                let item = self.movies[indexPath.row]
                let viewModel = MoviePreviewViewModel(title: item.original_name ?? item.original_title ?? "", youtubeView: element, movieOverView: item.overview ?? "")
                self.delegate?.MovieTableViewCellDidTapCell(self, viewModel: viewModel)
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", subtitle: nil, image: UIImage(systemName: "arrow.down.doc"), identifier: nil, discoverabilityTitle: nil,  state: .off) { _ in
                    self.downloadMovieAt(indexPath: indexPath)                }
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
    
}
