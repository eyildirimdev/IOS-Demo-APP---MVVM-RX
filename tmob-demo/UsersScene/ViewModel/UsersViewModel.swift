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
    let selectedIndexSubject = PublishSubject<IndexPath>()
    let searchQuerySubject = BehaviorSubject(value: "")
    
    // Outputs
    var users: Driver<[User]>
    var selectedUser: Driver<User?>
    
    private let dataRepository: DataRepository
    
    init(dataRepository: DataRepository) {
        self.dataRepository = dataRepository
        
        
        let usersRequest = self.searchQuerySubject
            .asObservable()
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance) // throttle to prevent api request overload -- can be replaced with debounce to ensure not exceeding daily api request quota
            .distinctUntilChanged()
            .flatMapLatest { query in
                dataRepository
                    .searchUser(withUserName: query)
            }
            .asDriver(onErrorJustReturn: [User]())
        
        
        self.users = usersRequest.map { $0.map { User(user: $0)} }
        
        self.selectedUser = self.selectedIndexSubject
            .asObservable()
            .withLatestFrom(users) { (indexPath, users) in
                return users[indexPath.item]
            }
            .asDriver(onErrorJustReturn: nil)
        
        
        
    }

}


