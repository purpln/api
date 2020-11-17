//
//  api.swift
//  app
//
//  Created by Sergey Romanenko on 12.11.2020.
//

import Foundation

func userToken() -> String {
    let str = UserDefaults.standard.object(forKey: "token") as? String
    return str == nil ? "" : str!
}

var information:Info = Info(api: "", version: "", description: "", error: false, data: "", seed: "")
var colors = [actionColors.values]()

class restapi{
    let key:String = "test"
    let url:String = "https://purpln.000webhostapp.com/test/"
    
    let headers = ["Content-Type": "application/json"]
    let session = URLSession(configuration: .default)
    var task: URLSessionDataTask?
    typealias results = (Data) -> Void
    typealias values = (Data?, Info) -> Void
    var observation: NSKeyValueObservation?
    
    func value(_ operation:operations, _ string:String, completion: @escaping results){
        task?.cancel()
        guard let URL = URL(string: url) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let post:[String : Any] = ["key":key, "operation":operation.rawValue, "values":string]
        do{
            request.httpBody = try? JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
        }
        task = session.dataTask(with: request as URLRequest) {data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task?.resume()
    }
    
    func values(_ operation:operations, _ string:[String:Any], completion: @escaping results){
        task?.cancel()
        guard let URL = URL(string: url) else { return }
        var request = URLRequest(url: URL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        let post:[String : Any] = ["key":key, "operation":operation.rawValue, "values":string]
        do{
            request.httpBody = try? JSONSerialization.data(withJSONObject: post, options: .prettyPrinted)
        }
        task = session.dataTask(with: request as URLRequest) {data, response, error in
            guard let data = data else { return }
            completion(data)
        }
        task?.resume()
    }
    
    func cancel(){
        task?.cancel()
    }
    
    func decode(_ data:Data, completion: @escaping values){
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(apiDate)
        if let json = try? decoder.decode(actionString.self, from: data) {
            DispatchQueue.main.async{
                completion(nil, json.info)
            }
        }else if let json = try? decoder.decode(actionError.self, from: data) {
            DispatchQueue.main.async{
                completion(nil, json.info)
            }
        }else{
            
            
            print(String(data: data, encoding: String.Encoding.utf8)!)
        }
    }
    
    enum operations:String{
        case echo
        case info
        case userLogin
        case createUser
        case updateValue
        case getUserByUsername
        case getUserByToken
        case listUsers
        case colors
    }
}

let apiDate:DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
}()
