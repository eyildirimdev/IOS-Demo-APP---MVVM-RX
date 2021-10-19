//
//  UserViewModel.swift
//  tmob-demo
//
//  Created by emir on 17.10.2021.
//

import Foundation
import RxSwift
import RxCocoa
final class UsersViewModel {
    // Inputs
    let viewWillAppearSubject = PublishSubject<Void>()
    let selectedIndexSubject = PublishSubject<IndexPath>()
    let searchQuerySubject = BehaviorSubject(value: "")
    
    // Outputs
    var users: Driver<[UserViewModel]>
    var selectedUsername: Driver<String>
    
    private let dataRepository: DataRepository
    
    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
        
        
        let users = self.searchQuerySubject
            .asObservable()
            .throttle(RxTimeInterval.milliseconds(3000), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest { query in
                dataRepository
                    .searchUser(withUserName: query)
            }
            .asDriver(onErrorJustReturn: [User]())
        
        
        self.users = users.map { $0.map { UserViewModel(user: $0)} }
        
        self.selectedUsername = self.selectedIndexSubject
            .asObservable()
            .withLatestFrom(users) { (indexPath, users) in
                return users[indexPath.item]
            }
            .map { $0.login }
            .asDriver(onErrorJustReturn: "")
    }

}

struct UserViewModel {
    let username: String
    let avatarUrl:String
}

extension UserViewModel {
    init(user: User) {
        self.username = user.login
        self.avatarUrl = user.avatar_url
    }
}
