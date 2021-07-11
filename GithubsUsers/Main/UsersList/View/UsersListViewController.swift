//
//  UsersListViewController.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import UIKit

class UsersListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: "UserListTableViewCell", bundle: nil), forCellReuseIdentifier: "UserListTableViewCell")
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let refreshControl = UIRefreshControl()
    lazy var viewModel: UsersListViewModel = {
        return UsersListViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Users".localized
        tableView.refreshControl = refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        vmInit()
    }
  // Events Binding + Data Binding
    func vmInit() {
        viewModel.reloadList = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                switch strongSelf.viewModel.state {
                case .empty, .error:
                    strongSelf.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 0.0
                    })
                case .loading:
                    strongSelf.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 0.0
                    })
                case .populated:
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.refreshControl.endRefreshing()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.tableView.alpha = 1.0
                    })
                case .failedToFetch:
                    strongSelf.activityIndicator.stopAnimating()
                    strongSelf.refreshControl.endRefreshing()
                    strongSelf.viewModel.alertMessage = "No internet connection."
                    UIView.animate(withDuration: 0.2, animations: {
                    strongSelf.tableView.alpha = 1.0
                    })
                }
            }
        }
        
        viewModel.pushUserDetailsViewController = { [weak self] () in
            guard let strongSelf = self else { return }
            if (NetworkManager.sharedInstance.reachability).connection != .unavailable || strongSelf.viewModel.selectedUserExistsInCD(name: (strongSelf.viewModel.selectedUser?.login)!) {
                DispatchQueue.main.async {
                    guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "UserDetailsViewController") as? UserDetailsViewController else {
                        fatalError("Could not instantiate ViewController: UserDetailsViewController")
                    }
                    strongSelf.navigationController?.pushViewController(vc, animated: true)
                    if let user = strongSelf.viewModel.selectedUser?.login {
                    let vm = UserDetailsViewModel(user: user)
                    vc.viewModel = vm
                    }
                }
            } else {
                AlertServices.showAlert("No User details in Data Base", viewController: strongSelf)
            }
        }
        
        viewModel.showAlert = { [weak self] () in
            DispatchQueue.main.async {
                guard let strongSelf = self else { return }
                if let message = strongSelf.viewModel.alertMessage {
                    AlertServices.showAlert(message, viewController: strongSelf)
                }
            }
        }
        
        viewModel.initFetch()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        // Fetch User Data
        viewModel.initFetch()
    }
}

extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell", for: indexPath) as? UserListTableViewCell else {
            fatalError("Cell not exists in storyboard")
        }
        
        let cellVM = viewModel.getCellViewModel(indexPath)
        cell.userListCellViewModel = cellVM
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.userPressed(at: indexPath)
    }
}
