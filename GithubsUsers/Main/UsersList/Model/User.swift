//
//  User.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import Foundation

enum TypeEnum: String, Codable {
    case organization = "Organization"
    case user = "User"
}

struct Users: Codable {
    let users: [User]
}

// MARK: - User
struct User: Codable {
    let login: String?
    let id: Int?
    let nodeID: String?
    let avatarURL: String?
    let gravatarID: String?
    let url: String?
    let htmlURL: String?
    let followersURL: String?
    let followingURL: String?
    let gistsURL: String?
    let starredURL: String?
    let subscriptionsURL: String?
    let organizationsURL: String?
    let reposURL: String?
    let eventsURL: String?
    let receivedEventsURL: String?
    let type: TypeEnum?
    let siteAdmin: Bool?

    enum CodingKeys: String, CodingKey {
        case login = "login"
        case id = "id"
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url = "url"
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type = "type"
        case siteAdmin = "site_admin"
    }
}

//// MARK: User convenience initializers and mutators
//
//extension User {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(User.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func with(
//        login: String?? = nil,
//        id: Int?? = nil,
//        nodeID: String?? = nil,
//        avatarURL: String?? = nil,
//        gravatarID: String?? = nil,
//        url: String?? = nil,
//        htmlURL: String?? = nil,
//        followersURL: String?? = nil,
//        followingURL: String?? = nil,
//        gistsURL: String?? = nil,
//        starredURL: String?? = nil,
//        subscriptionsURL: String?? = nil,
//        organizationsURL: String?? = nil,
//        reposURL: String?? = nil,
//        eventsURL: String?? = nil,
//        receivedEventsURL: String?? = nil,
//        type: TypeEnum?? = nil,
//        siteAdmin: Bool?? = nil
//    ) -> User {
//        return User(
//            login: login ?? self.login,
//            id: id ?? self.id,
//            nodeID: nodeID ?? self.nodeID,
//            avatarURL: avatarURL ?? self.avatarURL,
//            gravatarID: gravatarID ?? self.gravatarID,
//            url: url ?? self.url,
//            htmlURL: htmlURL ?? self.htmlURL,
//            followersURL: followersURL ?? self.followersURL,
//            followingURL: followingURL ?? self.followingURL,
//            gistsURL: gistsURL ?? self.gistsURL,
//            starredURL: starredURL ?? self.starredURL,
//            subscriptionsURL: subscriptionsURL ?? self.subscriptionsURL,
//            organizationsURL: organizationsURL ?? self.organizationsURL,
//            reposURL: reposURL ?? self.reposURL,
//            eventsURL: eventsURL ?? self.eventsURL,
//            receivedEventsURL: receivedEventsURL ?? self.receivedEventsURL,
//            type: type ?? self.type,
//            siteAdmin: siteAdmin ?? self.siteAdmin
//        )
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//typealias Users = [User]
//
//extension Array where Element == Users.Element {
//    init(data: Data) throws {
//        self = try newJSONDecoder().decode(Users.self, from: data)
//    }
//
//    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
//        guard let data = json.data(using: encoding) else {
//            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
//        }
//        try self.init(data: data)
//    }
//
//    init(fromURL url: URL) throws {
//        try self.init(data: try Data(contentsOf: url))
//    }
//
//    func jsonData() throws -> Data {
//        return try newJSONEncoder().encode(self)
//    }
//
//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
//}
//
//// MARK: - Helper functions for creating encoders and decoders
//
//func newJSONDecoder() -> JSONDecoder {
//    let decoder = JSONDecoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        decoder.dateDecodingStrategy = .iso8601
//    }
//    return decoder
//}
//
//func newJSONEncoder() -> JSONEncoder {
//    let encoder = JSONEncoder()
//    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//        encoder.dateEncodingStrategy = .iso8601
//    }
//    return encoder
//}
//
//// MARK: - UserRequest
//class UserRequest: RequestBase {
//
//    enum Route {
//        case getUser
//    }
//
//    private var route: Route
//
//    override var url: String {
//        switch self.route {
//        case .getUser:
//            return RequestConstants.API_User
//        }
//    }
//
//    override var method: RequestBaseHTTPMethod {
//        switch self.route {
//        case .getUser:
//            return .get
//        }
//    }
//
//    override var parameters: [String : Any] {
//        let parameters: [String : Any] = [:]
//        switch self.route {
//        case .getUser:
//            break
//        }
//        return parameters
//    }
//
//    init(_ route:Route) {
//        self.route = route
//    }
//}
