//
//  ViewController.swift
//  SimpleContactApp
//
//  Created by Aldo Leonardo on 09/05/20.
//  Copyright © 2020 Aldo Leonardo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    
    var contact = [Contact]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupPullRefresh()
        getRequest()
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getRequest()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setupNavbar() {
        navBar.title = "Contact"
        navBar.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        navBar.rightBarButtonItem?.tintColor = .black
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "contact"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 8, right: 99)
        button.sizeToFit()
        navBar.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    func setupPullRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        
        tableView.refreshControl = refreshControl
    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        getRequest()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func didTapAdd() {
        pushToDetailContact(contact: nil, HTTPMethod: .POST)
    }
    
    func pushToDetailContact(contact : Contact? = nil, HTTPMethod: HTTPMethod? = nil) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailContactVC = storyBoard.instantiateViewController(withIdentifier: "detailContact") as? DetailContactViewController {
            detailContactVC.contact = contact
            detailContactVC.HTTPMethod = HTTPMethod
            self.navigationController?.pushViewController(detailContactVC, animated: true)
        }
    }
    
    func getRequest() {
        let contactRequest = APIManager(endpoint: Constant.endpoint)
        contactRequest.sendRequest(nil, httpMethod: .GET, completion: { [weak self] result in
            switch result {
            case .failure(_ ):
                break
            case .success(let value):
                self?.contact = value
            }
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contact.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let contactCell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)as? ContactTableViewCell {
            contactCell.titleLabel.text = "\(contact[indexPath.row].firstName ?? "") \(contact[indexPath.row].lastName ?? "")"
            contactCell.detailLabel.text = "Age: \(contact[indexPath.row].age ?? 0)"
            return contactCell
        } else {
            return UITableViewCell.init()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contactRequest = APIManager(endpoint: "\(Constant.endpoint)/\(contact[indexPath.row].id ?? "")")
            contactRequest.sendRequest(nil, httpMethod: .DELETE, completion: { [weak self] result in
                switch result {
                case .failure(_ ):
                    print("contact unavailable")
                case .success(_ ):
                    self?.contact.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.tableView.reloadData()
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushToDetailContact(contact: contact[indexPath.row], HTTPMethod: .PUT)
    }
}
