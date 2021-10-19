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
        print("get users")
        return networkService.userService(url: URL(string: Endpoints.usersUrl)!,dataType: [User].self)
    }
    func searchUser(withUserName username: String) -> Observable<[User]>{
        print("get user for: " + username)
        if username.isEmpty {
            return networkService.userService(url: URL(string: Endpoints.usersUrl)!,dataType: [User].self)
        }
        let url = Endpoints.usersUrl + "/" + username
        return networkService.userService(url: URL(string: url)!,dataType: User.self)
    }
}

// General Network Service Class
class NetworkService{
    func userService<T: Decodable>(url:URL,dataType: T.Type) -> Observable<[User]>{
        return Observable.create{
            observer -> Disposable in
            let task = URLSession.shared.dataTask(with: url){data, response, error in

                if error != nil || data == nil {
                    //TODO Handle connection error onNext(error) or onFail(error)
                    return
                }
                let response = response as? HTTPURLResponse
                
                //Status code for 304 means "Not Modified" in the documentation on $BASEURL/users
                //404 error as defined in the documentation for $BASEURL/users/{username}. Return empty array of Users
                if(response?.statusCode == 404){
                    var result = [User]()
                    observer.onNext(result)
                    observer.onCompleted()
                    return
                }
                
                guard let data = data, let decoded = try? JSONDecoder().decode(T.self,from:data) else {
                    //TODO Handle parse error
                    
                    return
                }
                
                //Convert User object to User array for the purpose of showing at TableView
                if let user = decoded as? User{
                    var result = [User]()
                    result.append(user)
                    observer.onNext(result)
                    observer.onCompleted()
                    return
                }
                
                observer.onNext(decoded as! [User])
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
}

