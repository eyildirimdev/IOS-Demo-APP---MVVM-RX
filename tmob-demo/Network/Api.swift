//
//  Api.swift
//  tmob-demo
//
//  Created by emir on 17.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

//API Helper class
class DataRepository {
    private let networkService = NetworkService()
    func getUsersList() -> Observable<[User]>{
        return networkService.execute(url: URL(string: Endpoints.usersUrl)!)
    }
    func getUserDetail(withUserName username: String) -> Observable<User>{
        let url = Endpoints.usersUrl + "/" + username
        return networkService.execute(url: URL(string: url)!)
    }
}

// General Network Service Class
class NetworkService{
    func execute<T: Decodable>(url:URL) -> Observable<T>{
        return Observable.create{
            observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url){data, response, error in
                //Status code for 304 means "Not Modified" in the documentation on $BASEURL/users
                guard let response = response as? HTTPURLResponse, (200...209).contains(response.statusCode) || response.statusCode == 304 else {
                    //TODO possibly 404 error as defined in the documentation for $BASEURL/users/{username}
                    if error != nil{
                        observer.onError(error!)
                    }
                    return
                }
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self,from:data) else {
                    return
                    //TODO handle parse error
                }
                observer.onNext(decoded)
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

