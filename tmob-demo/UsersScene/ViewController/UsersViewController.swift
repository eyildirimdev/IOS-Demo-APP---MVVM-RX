//
//  ViewController.swift
//  tmob-demo
//
//  Created by emir on 16.10.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class UsersViewController: UIViewController {
    private var viewModel = UsersViewModel(dataRepository: DataRepository())
    var searchController = UISearchController(searchResultsController: nil)
    var userDataList = [String]()
    var savedUsername = ""
    var checkedUsersDict = [String:User]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        print("viewdidload")
        super.viewDidLoad()
        view.backgroundColor = .white
        definesPresentationContext = true

        searchController.searchResultsUpdater = nil
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        if let username = UserDefaults.standard.string(forKey: "savedUsername"){
            savedUsername = username
        }
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        tableView.rx.itemSelected
            .asObservable()
            .bind(to: viewModel.selectedIndexSubject)
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .asObservable()
            .bind(to: viewModel.searchQuerySubject)
            .disposed(by: disposeBag)

        
        viewModel.users
            .drive(tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = element.login
                if let avatarUrl = try? URL(string: element.avatar_url){
                    //TODO ADD PLACEHOLDER
                    cell.imageView?.kf.setImage(with: avatarUrl) { result in
                    cell.setNeedsLayout()
                    }
                    
                }
                if self.savedUsername.elementsEqual(element.login){
                    cell.backgroundColor = UIColor.lightGray
                }
                
            }
            .disposed(by: disposeBag)


        viewModel.selectedUser
            .drive(onNext: {user in
                self.startDetailVC(user: user!)
            })
            .disposed(by: disposeBag)
    }
    func saveUser(user:User){
        savedUsername = user.login
        UserDefaults.standard.set(savedUsername, forKey: "savedUsername")
        checkedUsersDict[savedUsername] = user
    }
    func startDetailVC(user:User){
        var userToSave = user
        if let savedUser = checkedUsersDict[userToSave.login]{
            userToSave = savedUser
        }
        self.userDataList = userToSave.userDataList
        performSegue(withIdentifier: "showDetails", sender: self)
        saveUser(user: userToSave)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetails") {
            let vc = segue.destination as? UserDetailViewController
            vc?.userDataList = self.userDataList
        }
    }
}

