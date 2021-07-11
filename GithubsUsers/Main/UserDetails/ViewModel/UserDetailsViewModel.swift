//
//  UserDetailsViewModel.swift
//  GithubsUsers
//
//  Created by Yaser on 7/7/21.
//

import UIKit
import CoreData

class UserDetailsViewModel {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var user: String
    var nameLabel: String = ""
    var avatarimageUrl: String = ""
    var followersLabel: String = ""
    var followingLabel: String = ""
    
    var updateLoadingStatus: (()->())?
    var updateViews: (()->())?
    
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    init(user: String) {
        self.user = user
        self.initFetch()
    }
    
    func initFetch() {
        state = .loading
        if (NetworkManager.sharedInstance.reachability).connection != .unavailable {
            print("Network is available")
            self.fetchDataFromApi()
        } else {
            print("Network is Unavailable")
            self.fetchDataFromCD()
        }
    }
    
    private func fetchDataFromApi() {
        APIService.fetchUserDetails(user: self.user) { [weak self] (result) in
            
            guard let strongSelf = self else { return }
            switch result {
            case .success(let userDetails):
                strongSelf.nameLabel = userDetails.name ?? ""
                strongSelf.avatarimageUrl = userDetails.avatarURL ?? ""
                strongSelf.followersLabel = "\(userDetails.followers ?? 0)"
                strongSelf.followingLabel = "\(userDetails.following ?? 0)"
                
                let userDetaildCD = UserDetails_CD(context: strongSelf.context)
                userDetaildCD.name = userDetails.name
                userDetaildCD.image = userDetails.login
                userDetaildCD.followers = Int16(userDetails.followers ?? 0)
                userDetaildCD.following = Int16(userDetails.following ?? 0)
                if !strongSelf.someEntityExists(name: userDetails.name!) {// check if object doesnt exist then save it
                    strongSelf.saveContext()
                }
                strongSelf.state = .populated
                strongSelf.updateViews?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchDataFromCD() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails_CD")
        request.predicate = NSPredicate(format: "name == %@", self.user)
        
        do{
            let test = try context.fetch(request)
            let object = test[0] as! NSManagedObject
            self.nameLabel = object.value(forKey: "name") as! String
            self.followersLabel = object.value(forKey: "followers") as! String
            self.followingLabel = object.value(forKey: "following") as! String
            self.state = .populated
            self.updateViews?()
          }
        catch let error as NSError {
             print("Could not fetch \(error), \(error.userInfo)")
          }
    }
    // Saving to Core data
    private func saveContext() {
        do {
            try self.context.save()
        } catch  {
            print("saving problem")
        }
    }

    func someEntityExists(name: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetails_CD")
        let predicate = NSPredicate(format: "name == %@", name)
        request.predicate = predicate
        request.fetchLimit = 1

        do{
            let results = try context.fetch(request)
            if( results.count == 0) {
            return false
            } else {
                return true
            }
          }
        catch let error as NSError {
            return false
             print("Could not fetch \(error), \(error.userInfo)")
          }
    }
}
