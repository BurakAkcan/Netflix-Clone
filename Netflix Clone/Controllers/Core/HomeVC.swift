//
//  HomeVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

enum Section:Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case UpComing = 3
    case TopRated = 4
}

class HomeVC: UIViewController {
    
    //MARK: - Properties
    
    let sectionTitles:[String] = ["Trending Movies","Popular","Trending TV","Upcoming Movie","Top Rated"]
    var movieList:Movies = []
    
    
    //MARK: - UIViews
    
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero,style: .grouped)
        table.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        let headerView = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        
        //TableView a HeaderView verebiliriz
        homeFeedTable.tableHeaderView = headerView
        
        configureNavBar()
    }
    
     private func configureNavBar(){
        var image = UIImage(named: "ic_netflix")
        image = image?.withRenderingMode(.alwaysOriginal)//Resim daima orjinalliğini korur
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else{ return UITableViewCell() }
        cell.delegate = self
        
        switch indexPath.section {
        case Section.TrendingMovies.rawValue:
            APICaller.shared.getTrending { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Section.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Section.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        case Section.UpComing.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                   // print(movies)
                }
            }
        case Section.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result{
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let movies):
                    cell.configure(with: movies)
                }
            }
        
        default:
            return UITableViewCell()
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top // Yukarıdaki top SafeArea yüksekliği
        
        let offset = scrollView.contentOffset.y + defaultOffset
        
        //NavigationBarı yavaşça gizlemek için transform metodnu kullanabiliriz
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset + 20))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        return sectionTitles[section]
    }
    
    //Sectionların textini düzenlediğimiz yer
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else{return}
        header.textLabel?.textColor = .label
        header.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)   
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20 , y: header.bounds.origin.y, width: 100, height: header.bounds.height)
    }
}


extension HomeVC:MovieTableViewCellDelegate{
    func MovieTableViewCellDidTapCell(_ cell: MovieTableViewCell, viewModel: MoviePreviewViewModel) {
        
        DispatchQueue.main.async {
            let vc = MoviePreviewVC()
            vc.configure(with: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}
