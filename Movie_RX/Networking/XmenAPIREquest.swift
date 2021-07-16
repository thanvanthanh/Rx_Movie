//
//  XmenAPIREquest.swift
//  Movie_RX
//
//  Created by Thân Văn Thanh on 09/07/2021.
//


import Foundation
import RxSwift
import RxCocoa


class XmenAPIRequest {
    let baseURL = URL(string: "https://www.omdbapi.com/?s=x-men&apikey=564727fa")
    var method = RequestType.GET
    var parameters = [String : String]()
    
    func request(with baseURL : URL) -> URLRequest{
        var request = URLRequest(url: baseURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}

class XmenAPICalling{
    
    func send<T:Codable>(apiRequest : XmenAPIRequest) ->Observable<T>{
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: apiRequest.baseURL!)
            let task = URLSession.shared.dataTask(with: request) { (data , response , error) in
                do{
                    let model : XMovie = try JSONDecoder().decode(XMovie.self, from: data ?? Data())
                    observer.onNext(model.search as! T )
                }catch let error{
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create(){
            task.cancel()
            }
        }
    }
}
