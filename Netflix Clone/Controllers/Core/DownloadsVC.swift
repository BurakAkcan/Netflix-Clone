//
//  DownloadsVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

class DownloadsVC: UIViewController {
    
   private var movies:[MovieItem] = []
    
    private let downloadTable:UITableView = {
       let tableView = UITableView()
        tableView.register(UpComingTableCell.self, forCellReuseIdentifier: UpComingTableCell.identifer)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Download"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadTable)
        downloadTable.delegate = self
        downloadTable.dataSource = self
        fetchLocalStorage()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorage()
            self.presentAlertOnMainThread(title: "Saved", message: "The movie saved database", buttonTitle: "Ok")
        }

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    private func fetchLocalStorage(){
        DataPersistanceManager.shared.fetchMoviesFromDatabase { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.downloadTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadTable.frame = view.bounds
    }
    


}

extension DownloadsVC:UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpComingTableCell.identifer, for: indexPath) as? UpComingTableCell else{
            return UITableViewCell()
        }
        let item = movies[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: item.original_name ?? item.poster_path ?? "", posterUrl: item.poster_path ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            DataPersistanceManager.shared.deleteMovie(model: movies[indexPath.row]) { [weak self] result in
                guard let self = self else{return}
                switch result {
                case .success():
                    self.downloadTable.reloadData()
                    self.presentAlertOnMainThread(title: "Deleted", message: "Succes to delete movie", buttonTitle: "Ok")
                case .failure(let error):
                    self.presentAlertOnMainThread(title: "Error", message: error.localizedDescription, buttonTitle: "Ok")
                }
                self.movies.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = movies[indexPath.row]
        guard let movieName = movie.original_title ?? movie.original_name else{return}
        APICaller.shared.getMovie(with: movieName) { [weak self] result in
            guard let self = self else{return}
            switch result{
            case .success(let element):
                DispatchQueue.main.async {
                    let vc = MoviePreviewVC()
                    vc.configure(with: MoviePreviewViewModel(title: movieName, youtubeView: element, movieOverView: movie.overview ?? "Unknown"))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
