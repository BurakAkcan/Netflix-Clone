//
//  HomeVC.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: -UIViews
    
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero,style: .grouped)
        table.register(CollectionViewTableCell.self, forCellReuseIdentifier: CollectionViewTableCell.identifier)
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
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableCell.identifier, for: indexPath) as? CollectionViewTableCell else{ return UITableViewCell() }
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
}
