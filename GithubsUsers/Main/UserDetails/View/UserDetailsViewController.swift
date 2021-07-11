//
//  UserDetailsViewController.swift
//  GithubsUsers
//
//  Created by Yaser on 7/7/21.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    
     var viewModel: UserDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vmInit()
    }
    
    func vmInit() {
        viewModel?.updateViews = { [weak self] () in
            guard let strongSelf = self else { return }
            guard let vm = strongSelf.viewModel else { return }
            DispatchQueue.main.async {
            strongSelf.nameLabel.text = vm.nameLabel
            strongSelf.followersLabel.text = vm.followersLabel
            strongSelf.followingLabel.text = vm.followingLabel
            strongSelf.avatarImageView?.sd_setImage(with: URL( string: vm.avatarimageUrl), completed: nil)
            }
        }
        
        viewModel?.updateLoadingStatus = { [weak self] () in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async { [weak self] in
                guard let strongSelf = self else {
                    return
                }
                switch strongSelf.viewModel?.state {
                case .empty, .error:
                    strongSelf.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.stackView.alpha = 0.0
                    })
                case .loading:
                    strongSelf.activityIndicator.startAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.stackView.alpha = 0.0
                    })
                case .populated:
                    strongSelf.activityIndicator.stopAnimating()
                    UIView.animate(withDuration: 0.2, animations: {
                        strongSelf.stackView.alpha = 1.0
                    })
                case .failedToFetch:
                    strongSelf.activityIndicator.stopAnimating()
                    AlertServices.showAlert("No internet connection.", viewController: self!)
                    UIView.animate(withDuration: 0.2, animations: {
                    strongSelf.stackView.alpha = 1.0
                    })
                case .none:
                    break
                }
            }
        }    }
}
