//
//  UserDetailViewController.swift
//  tmob-demo
//
//  Created by emir on 19.10.2021.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UserDetailViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var userDataList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        definesPresentationContext = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.userDataList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = (self.tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell?)!
          cell.textLabel?.text = self.userDataList[indexPath.row]
          
          return cell
      }
      
}


