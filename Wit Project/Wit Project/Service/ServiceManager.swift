//
//  ServiceManager.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import Foundation

class ServiceManager{
    static let shared = ServiceManager()
    private let configuration: URLSessionConfiguration
    private let session: URLSession
    private let urlString = "https://api.github.com/users"
    private var imageCache = NSCache <NSString, NSData>()
    private var userInfoCache = NSCache <NSString , InfoUserObject>()
    let limit: String = "10"
    
    private init() {
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    //MARK: - User List
    func getUserListFromService(since: Int , completion: @escaping (Result<[UsersObject], Error>) -> (Void)) {
        let url = URL(string:"\(urlString)?since=\(since)&per_page=\(limit)")
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {data,response,error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 999, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 998, userInfo:nil)
                completion(.failure(error))
                return
            }
            
            do {
                let itens = try JSONDecoder().decode([UsersObject].self, from: data)
                completion(.success(itens))
            }catch let error{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - User Info
    func getUserInfo(userName: String, idObject: String,completion: @escaping (Result <InfoUserObject, Error>) -> Void){
        if let infoData = self.userInfoCache.object(forKey: idObject as NSString) as InfoUserObject?{
            completion(.success(infoData))
            return
        }
        let url = URL(string: urlString + "/" + userName)
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {data,response,error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 999, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 998, userInfo:nil)
                completion(.failure(error))
                return
            }
            
            do {
                let userInfo = try JSONDecoder().decode(InfoUserObject.self, from: data)
                self.userInfoCache.setObject(userInfo as InfoUserObject, forKey: idObject as NSString)
                completion(.success(userInfo))
            }catch let error{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    func getUserInfo(userName: String,completion: @escaping (Result <InfoUserObject, Error>) -> Void){
        let url = URL(string: urlString + "/" + userName)
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {data,response,error in
            if let error = error{
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 999, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: 998, userInfo:nil)
                completion(.failure(error))
                return
            }
            
            do {
                let userInfo = try JSONDecoder().decode(InfoUserObject.self, from: data)
                completion(.success(userInfo))
            }catch let error{
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    //MARK: - Get Images
    func getImageUserInfoWith(url urlImage: URL, idFile: String, completion: @escaping (Result <Data, Error>) -> Void){
        /// if have image in cache i use this data.
        if let infoImageDate = self.imageCache.object(forKey: idFile as NSString) as Data?{
            completion(.success(infoImageDate))
            return
        }
        
        let urlRequest = URLRequest(url: urlImage)
        let taks = session.downloadTask(with: urlRequest) { localURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                let error = NSError(domain: "", code: 999, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                let error = NSError(domain: "", code: response.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let localURL = localURL else{
                let error = NSError(domain: "", code: 998, userInfo:nil)
                completion(.failure(error))
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                self.imageCache.setObject(data as NSData, forKey: idFile as NSString)
                completion(.success(data))
            }catch let error{
                completion(.failure(error))
            }
        }
        
        taks.resume()
    }
}
