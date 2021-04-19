//
//  NetworkManager.swift
//  UserPaymentsApp
//
//  Created by Дмитрий Кузнецов on 17.04.2021.
//

import Foundation

// Стандартные поля заполнения в URL
enum URLDefaultFields: String {
    case appKey = "app-key"
    case version = "v"
}

// MARK: - NetworkManager class
class NetworkManager {
    static var shared = NetworkManager()
    
    private var urlDefaultSettings: [URLDefaultFields: String] = [.appKey: "12345",
                                                                  .version: "1"]
    
    private init() {}
    
    // MARK: postData Отправка данных на сервер и обработка ответа
    func postData(url: String, login: String, password: String,
                  complition: @escaping (UserResponceData)->Void) {
        var data: Data?
        
        guard let url = URL(string: url) else {
            print("URL error")
            return
        }
        
        let user = UserLoginPostData(login: login, password: password)
        do{
            data = try JSONEncoder().encode(user)
        } catch let error {
            print("Decode error: \(error)")
        }
        
        var postDataRequest = URLRequest(url: url)
        postDataRequest.addValue(urlDefaultSettings[.appKey] ?? "",
                                 forHTTPHeaderField: URLDefaultFields.appKey.rawValue)
        postDataRequest.addValue(urlDefaultSettings[.version] ?? "",
                                 forHTTPHeaderField: URLDefaultFields.version.rawValue)
        postDataRequest.httpMethod = "POST"
        postDataRequest.httpBody = data
        
        URLSession.shared.dataTask(with: postDataRequest) { (data, _, error) in
            if let error = error {
                print("Requst error: \(error)")
                return
            }
            
            guard let data = data else { return }
            do {
                let responceData = try JSONDecoder().decode(UserResponceData.self, from: data)
                complition(responceData)
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    // MARK: getData Запрос данных с сервера и обработка ответа
    func getPaymentsData(url: String,
                         token: String,
                         complition: @escaping (UserPaymentsResponceData)->Void) {
        var urlComponents = URLComponents(string: url)
        urlComponents?.queryItems = [URLQueryItem(name: "token", value: token)]
        
        guard let urlRequest = urlComponents?.url else {
            print("URL error")
            return
        }
        
        var getRequestData = URLRequest(url: urlRequest)
        getRequestData.addValue(urlDefaultSettings[.appKey] ?? "",
                                 forHTTPHeaderField: URLDefaultFields.appKey.rawValue)
        getRequestData.addValue(urlDefaultSettings[.version] ?? "",
                                 forHTTPHeaderField: URLDefaultFields.version.rawValue)
        
        URLSession.shared.dataTask(with: getRequestData) { (data, _, error) in
            if let error = error {
                print("Requst error: \(error)")
                return
            }
            
            guard let data = data else { return }
            
            do {
                let responceData = try JSONDecoder().decode(UserPaymentsResponceData.self, from: data)
                complition(responceData)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
