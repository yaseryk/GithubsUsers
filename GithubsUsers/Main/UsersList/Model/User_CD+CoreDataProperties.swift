//
//  User_CD+CoreDataProperties.swift
//  GithubsUsers
//
//  Created by Yaser on 7/10/21.
//
//

import Foundation
import CoreData


extension User_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User_CD> {
        return NSFetchRequest<User_CD>(entityName: "User_CD")
    }

    @NSManaged public var image: String?
    @NSManaged public var userName: String?
    @NSManaged public var userDetails: UserDetails_CD?
}

extension User_CD : Identifiable {

}
