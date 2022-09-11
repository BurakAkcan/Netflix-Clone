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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
        let cell = upComingTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = upComingList[indexPath.row].original_name ?? upComingList[indexPath.row].original_title ?? "Unknown"
        return cell
    }
}
