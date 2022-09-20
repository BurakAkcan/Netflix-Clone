//
//  DataPersistanceManager.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 15.09.2022.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError:LocalizedError{
    case failedToSave
    case failedFetchData
    case failedDeleteItemFromDatabase
    
    var errorDescription: String?  {
        switch self {
        case .failedToSave:
            return "Error to saving item"
        case .failedFetchData:
            return "Error to fetching datas"
        case .failedDeleteItemFromDatabase:
            return "Error to delete item"
        }
    }
    
}

class DataPersistanceManager{
    static let shared = DataPersistanceManager()
    private init(){}
            
    func downloadMovie(model:Movie,completion:@escaping (Result<Void,Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let item = MovieItem(context: context)
        item.original_title = model.original_title
        item.id = Int64(model.id)
        item.overview = model.overview
        item.original_name = model.original_name
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
       // context.save()
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            print(error.localizedDescription)
            completion(.failure(DatabaseError.failedToSave))
        }
    }
    
    func fetchMoviesFromDatabase(comletion:@escaping (Result<[MovieItem],Error>)->Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = appDelegate.persistentContainer.viewContext
        let request:NSFetchRequest<MovieItem>
        request = MovieItem.fetchRequest()
        
        do{
          let movies = try context.fetch(request)
            comletion(.success(movies))
        }catch{
            comletion(.failure(DatabaseError.failedFetchData))
            
        }
    }
    
    func deleteMovie(model:MovieItem,completion:@escaping (Result<Void,Error>)->Void){
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else{return}
        let context = delegate.persistentContainer.viewContext
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }catch{
            completion(.failure(DatabaseError.failedDeleteItemFromDatabase))
        }
    }
}
