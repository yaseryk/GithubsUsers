//
//  RequestBuilder.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import Foundation
import Alamofire
import SVProgressHUD

class RequestBuilder {
    
    static let shared = RequestBuilder()
    
    func sendRequest(_ request: RequestBase, completion: @escaping (User) -> Void) {
        let headers: HTTPHeaders = []
        AF.request(request.url, method: getMethodOfRequest(request), parameters: getMethodOfRequest(request) == .post ? request.parameters : nil, encoding: JSONEncoding.default, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseJson = try User(data: data)
                    completion(responseJson)
                } catch let err {
                    print("error: \(err)")
                }
            case .failure(let err ):
                print("error: \(err)")
                break
            }
        }
    }
    
    func getMethodOfRequest(_ reqest:RequestBase) -> HTTPMethod {
        switch reqest.method {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        }
    }
    
    func isShowLoader(_ isShowed : Bool) {
        if isShowed{
            SVProgressHUD.setDefaultMaskType(.black)
            SVProgressHUD.setBackgroundColor(UIColor.white)
            SVProgressHUD.show()
        }else{
            SVProgressHUD.dismiss()
        }
    }
}

