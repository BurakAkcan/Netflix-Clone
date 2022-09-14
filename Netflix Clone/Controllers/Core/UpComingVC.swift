//
//  UpComingVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

class UpComingVC: UIViewController {
    
    var upComingList:Movies = []
    
    private let upComingTableView:UITableView = {
       let tableView = UITableView()
        tableView.register(UpComingTableCell.self, forCellReuseIdentifier: UpComingTableCell.identifer)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upComingTableView)
        upComingTableView.delegate = self
        upComingTableView.dataSource = self
        fetchUpComing()
        

    }
    
    override func viewDidLayoutSubviews() {
        upComingTableView.frame = view.bounds
    }
    
    private func fetchUpComing(){
        APICaller.shared.getUpcomingMovies {[weak self] result in
            guard let self = self else{return}
            switch result {
            case .success(let movies):
                self.upComingList = movies
                DispatchQueue.main.async {
                    self.upComingTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    

}

extension UpComingVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upComingList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UpComingTableCell.identifer, for: indexPath) as? UpComingTableCell
        else {return UITableViewCell()}
        let item = upComingList[indexPath.row]
        cell.configure(with: MovieViewModel(titleName: item.original_title ?? item.original_name ?? "Unknown", posterUrl: item.poster_path ?? ""))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let movie = upComingList[indexPath.row]
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
