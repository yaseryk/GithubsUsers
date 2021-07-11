//
//  UserDetails_CD+CoreDataProperties.swift
//  GithubsUsers
//
//  Created by Yaser on 7/11/21.
//
//

import Foundation
import CoreData


extension UserDetails_CD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails_CD> {
        return NSFetchRequest<UserDetails_CD>(entityName: "UserDetails_CD")
    }

    @NSManaged public var followers: Int16
    @NSManaged public var following: Int16
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var ownerUser: User_CD?

}

extension UserDetails_CD : Identifiable {

}
