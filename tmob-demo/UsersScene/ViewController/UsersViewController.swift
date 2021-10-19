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
        
        bindViewModel()
    }
    
    private func bindViewModel() {
        rx.viewWillAppear
            .asObservable()
            .bind(to: viewModel.viewWillAppearSubject)
            .disposed(by: disposeBag)
        
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
                cell.textLabel?.text = element.username
                if let avatarUrl = try? URL(string: element.avatarUrl){
                    //TODO ADD PLACEHOLDER
                    cell.imageView?.kf.setImage(with: avatarUrl) { result in
                    cell.setNeedsLayout()
                    }
                }
               
                
            }
            .disposed(by: disposeBag)


        viewModel.selectedUsername
            .drive(onNext: { [weak self] username in
                guard let strongSelf = self else { return }
                let alertController = UIAlertController(title: "\(username)", message: nil, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                strongSelf.present(alertController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}
extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
}
