//
//  ServiceManager.swift
//  Wit Project
//
//  Created by Hugo Regadas on 23/09/2021.
//

import Foundation

class ServiceManager{
    static let shared = ServiceManager()
    let configuration: URLSessionConfiguration
    let session: URLSession
    let urlString = "https://api.github.com/users"
    private var imageCache = NSCache <NSString, NSData>()
    private var userInfoCache = NSCache <NSString , InfoUserObject>()
    
    
    private init() {
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    //MARK: - User List
    func getUserListFromService (completion: @escaping ([UsersObject]) -> (Void)) {
        let url = URL(string:urlString)
        
        guard let url = url else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) {data,response,error in
            if let error = error{
                print("""
                    #############   Error ############
                    Erro na chamada do serviço
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("""
                    #############   Error ############
                    Erro no Response
                    \(response.debugDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("""
                    #############   Error ############
                    \(response.statusCode)
                    #############   Error ############
                    """)
                return
            }
            
            guard let data = data else {
                print("""
                    #############   Error ############
                    Não está a retornar dados.
                    #############   Error ############
                    """)
                return
            }
            
            do {
                let itens = try JSONDecoder().decode([UsersObject].self, from: data)
                completion(itens)
            }catch let error{
                print("""
                    #############   Error ############
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
            }
        }
        
        task.resume()
    }
    
    //MARK: - User Info
    func getUserInfo(userName: String, idObject: String,completion: @escaping (_ userInfo : InfoUserObject) -> Void){
        if let infoData = self.userInfoCache.object(forKey: idObject as NSString){
            print("Cache")
            completion(infoData as InfoUserObject)
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
                print("""
                    #############   Error ############
                    Erro na chamada do serviço
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("""
                    #############   Error ############
                    Erro no Response
                    \(response.debugDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("""
                    #############   Error ############
                    \(response.statusCode)
                    #############   Error ############
                    """)
                return
            }
            
            guard let data = data else {
                print("""
                    #############   Error ############
                    Não está a retornar dados.
                    #############   Error ############
                    """)
                return
            }
            
            do {
                let userInfo = try JSONDecoder().decode(InfoUserObject.self, from: data)
                self.userInfoCache.setObject(userInfo as InfoUserObject, forKey: idObject as NSString)
                completion(userInfo)
            }catch let error{
                print("""
                    #############   Error ############
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
            }
        }
        
        task.resume()
    }
    
    //MARK: - Get Images
    func getImageUserInfoWith(url urlImage: URL, idFile: String, completion: @escaping (_ data: Data) -> Void){
        if let infoImageDate = self.imageCache.object(forKey: idFile as NSString){
            print("Cache")
            completion(infoImageDate as Data)
            return
        }
        
        let urlRequest = URLRequest(url: urlImage)
        let taks = session.downloadTask(with: urlRequest) { localURL, response, error in
            if let error = error {
                print("""
                    #############   Error ############
                    Erro na chamada do serviço
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("""
                    #############   Error ############
                    Erro no Response
                    \(response.debugDescription)
                    #############   Error ############
                    """)
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                print("""
                    #############   Error ############
                    \(response.statusCode)
                    #############   Error ############
                    """)
                return
            }
            
            guard let localURL = localURL else{
                print("""
                    #############   Error ############
                    Não está a retornar dados.
                    #############   Error ############
                    """)
                return
            }
            
            do {
                let data = try Data(contentsOf: localURL)
                self.imageCache.setObject(data as NSData, forKey: idFile as NSString)
                completion(data)
                
            }catch let error{
                print("""
                    #############   Error ############
                    \(error.localizedDescription)
                    #############   Error ############
                    """)
            }
        }
        
        taks.resume()
    }
}
