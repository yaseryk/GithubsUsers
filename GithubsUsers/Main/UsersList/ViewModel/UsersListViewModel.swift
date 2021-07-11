//
//  UsersListViewModel.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import UIKit
import SDWebImage
import CoreData

enum State {
    case loading
    case error
    case empty
    case populated
    case failedToFetch
}

class UsersListViewModel: NSObject {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var users = [User]()
    private var usersCD = [User_CD]()
    
  //Closures to bind events with the VC
    var reloadList: (()->())?
    var showAlert: (()->())?
    var updateLoadingStatus: (()->())?
    var pushUserDetailsViewController: (()->())?
    
    private var cellViewModels: [UserListCellViewModel] = [UserListCellViewModel]() {
        didSet {
            self.reloadList?()
        }
    }
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var isUsersEmpty: Bool {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User_CD")
            let count  = try context.count(for: request)
            return count == 0
        } catch {
            return true
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlert?()
        }
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var selectedUser: User? {
        didSet {
            self.pushUserDetailsViewController?()
        }
    }
    
    func initFetch() {
        // If fetching is requested and there is internet connection fetch from internet, else if there is previouse data should be fetched from DB otherwise state that there the fetching failed with empty table.
        NetworkManager.isReachable { [weak self] networkManagerInstance in
            guard let strongSelf = self else { return }
            print("Network is available")
            strongSelf.state = .loading
            strongSelf.fetchDataFromApi()
        }
        
        NetworkManager.isUnreachable { [weak self] networkManagerInstance in
            guard let strongSelf = self else { return }
            print("Network is Unavailable")
            if strongSelf.isUsersEmpty {
                strongSelf.state = .failedToFetch
            } else {
                strongSelf.fetchDataFromCD()
                strongSelf.alertMessage = "fetched from Core Data"
            }
        }
    }
    
    private func fetchDataFromApi() {
        APIService.fetchUsers { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let users):
                strongSelf.deleteAllData(entity: "User_CD") {// replace previous Core Data to update with new data from api
                    strongSelf.processFetchedUser(users)
                    strongSelf.state = .populated
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func processFetchedUser(_ users: [User]) {
        self.users = users // Cache
        var vms = [UserListCellViewModel]()// create UserListCellViewModel from api results
        for user in users {
            vms.append(createCellViewModel(user))
            let userCD = User_CD(context: self.context)
            userCD.userName = user.login
            
            guard let avatarUrl = user.avatarURL else { return }
            
            SDWebImageManager.shared.loadImage(
                with: URL(string: avatarUrl),
                options: .highPriority,
                progress: nil) { [weak self] (image, data, error, cacheType, isFinished, imageUrl) in
                guard let strongSelf = self else { return }
                guard let image = image else { return }
                if strongSelf.saveImage(imageName: user.login!, image: image) {
                    userCD.image = user.login
                }
                strongSelf.saveContext()
            }
        }
        self.cellViewModels = vms
    }
    // Saving to Core data
    private func saveContext() {
        do {
            try self.context.save()
        } catch  {
            print("saving problem")
        }
    }
    
    private func fetchDataFromCD() {
        do {
            let users = try self.context.fetch(User_CD.fetchRequest()) as [User_CD] // fetch data from data base
            processFetchedUserFromCD(users)
            self.state = .populated
        } catch  {
            print("fetching data fom CD problem")
        }
    }
    
    private func processFetchedUserFromCD(_ users: [User_CD]) {
        self.usersCD = users // Cache
        var vms = [UserListCellViewModel]()//create UserListCellViewModel from core data objects
        for user in users {
            vms.append(createCellViewModelFromCD(user))
        }
        self.cellViewModels = vms
    }
    
    private func createCellViewModelFromCD(_ user: User_CD) -> UserListCellViewModel {
       // let image = getSavedImage(named: user.userName ?? "")
        return UserListCellViewModel(nameText: user.userName ?? "", image: user.image! )
    }
    
    private func createCellViewModel(_ user: User) -> UserListCellViewModel {
//        var image = UIImage()
//        fetchImage(user.avatarURL!) { (image_) in
//            image = image_
//        }
        return UserListCellViewModel(nameText: user.login ?? "", image: user.avatarURL!)
    }
    
    func fetchImage(_ image: String, completion : @escaping (UIImage) -> ()) {
        SDWebImageManager.shared.loadImage(
            with: URL(string: image),
            options: .highPriority,
            progress: nil) { (image, data, error, cacheType, isFinished, imageUrl) in
            guard let image = image else { return }
            completion(image)
        }
    }
    
    func getCellViewModel(_ indexpath: IndexPath) -> UserListCellViewModel {
        return cellViewModels[indexpath.row]
    }
    
    func userPressed(at indexPath: IndexPath) {
        self.selectedUser = users[indexPath.row]
    }
    
    func saveImage(imageName: String, image: UIImage) -> Bool {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false }
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return false}
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
            return true
        } catch let error {
            print("error saving file with error", error)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    func deleteAllData(entity: String, completion : @escaping ()->()) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        DispatchQueue.main.async {
            do {
                let results = try self.context.fetch(fetchRequest)
                
                for managedObject in results {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    self.context.delete(managedObjectData)
                }
                completion()
            } catch let error as NSError {
                print("Delete all data in \(entity) error : \(error) \(error.userInfo)")
            }
        }
    }
    
    func selectedUserExistsInCD(name: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserDetails_CD")
        fetchRequest.predicate = NSPredicate(format: "name = %d", name)

        var results: [NSManagedObject] = []

        do {
            results = try context.fetch(fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return results.count > 0
    }
}
