//
//  APICaller.swift
//  Netflix Clone
//
//  Created by Burak AKCAN on 10.09.2022.
//

import Foundation

struct Constants{
    static let APIKey:String  = "cd42c3e6482ca41c298fb893cf2f60dc"
    static let baseUrl:String = "https://api.themoviedb.org"
}


class APICaller{
    static let shared = APICaller()
    private init(){}
    
    func getTrending(completion:@escaping (Result<Movies,Error>)->Void ){
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/all/day?api_key=\(Constants.APIKey)" ) else {return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                   error == nil else {return}
            
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(movies.results))
                
            }catch{
                completion(.failure(AppError.errorDecoding))
                print(error.localizedDescription)
            }
            
            }
        task.resume()
        
        
        
    }
    
    
    func getTrendingTvs(completion:@escaping (Result<Movies,Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/trending/tv/day?api_key=\(Constants.APIKey)") else{return}
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                print("url hatası")
                completion(.failure(AppError.invalidUrl))
            }
            guard let data = data else {
                print("data hatası")
                completion(.failure(AppError.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(movies.results))
                
            }catch{
                print("decode hatası")
                    completion(.failure(AppError.errorDecoding))
            }
            

            
        }
        task.resume()
    }
    
    #warning("Edit this func")
    func getUpcomingMovies(completion:@escaping (Result<Movies,Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/upcoming?api_key=\(Constants.APIKey)&language=en-US&page=1") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(AppError.invalidUrl))
            }
            guard let response = response as? HTTPURLResponse,
            response.statusCode == 200 else {
                completion(.failure(AppError.invalidResponse))
                return}
            guard let data = data else {
                completion(.failure(AppError.invalidData))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(movies.results))
               // print(movies)
            }catch{
                completion(.failure(AppError.errorDecoding))
            }


        }
        task.resume()
        
    }
    
    func getPopularMovies(completion:@escaping (Result<Movies,Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/popular?api_key=\(Constants.APIKey)&language=en-US&page=1") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(AppError.invalidUrl))
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else{
                completion(.failure(AppError.invalidResponse))
                return
            }
            guard let data = data else {
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(movies.results))
            }catch{
                completion(.failure(AppError.errorDecoding))
            }

        }
        task.resume()
    }
    
    func getTopRated(completion:@escaping (Result<Movies,Error>)->Void){
        guard let url = URL(string: "\(Constants.baseUrl)/3/movie/top_rated?api_key=\(Constants.APIKey)&language=en-US&page=1") else{return}
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(AppError.invalidUrl))
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else{
                completion(.failure(AppError.invalidResponse))
                return
            }
            guard let data = data else {
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let movies = try decoder.decode(TrendingTitleResponse.self, from: data)
                completion(.success(movies.results))
            }catch{
                completion(.failure(AppError.errorDecoding))
            }

        }
        task.resume()
    }
    
    
}
// https://api.themoviedb.org/3/movie/upcoming?api_key=<<api_key>>&language=en-US&page=1
//https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>&language=en-US&page=1
