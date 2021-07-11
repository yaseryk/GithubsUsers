//
//  UserListTableViewCell.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import UIKit
import SDWebImage

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var userListCellViewModel : UserListCellViewModel? {
        didSet {
            nameLabel.text = userListCellViewModel?.nameText
            //if there is internet connection fetch data if not bring from DB
            if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
                self.avatarImageView?.sd_setImage(with: URL(string: userListCellViewModel?.image ?? "" ), completed: nil)
            } else {
                self.avatarImageView?.image = getSavedImage(named: userListCellViewModel!.nameText)
            }
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
