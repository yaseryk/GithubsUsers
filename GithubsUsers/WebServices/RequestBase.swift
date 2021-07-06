//
//  RequestBase.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import Foundation

public enum RequestBaseHTTPMethod: String {
    case get
    case post
    case put
    case delete
}

class RequestBase: NSObject {
    public var url : String {
        return ""
    }
    public var parameters : [String : Any] {
        return [:]
    }
    public var requestObject : Any! {
        return nil
    }
    public var method : RequestBaseHTTPMethod {
        return .post
    }
    public var responseReplacing : Dictionary<String, String>? {
        return nil
    }
}
