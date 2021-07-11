//
//  ApiServices.swift
//  GithubsUsers
//
//  Created by Yaser on 7/6/21.
//

import Foundation
//import Alamofire
//import SVProgressHUD

//class RequestBuilder {
//
//    static let shared = RequestBuilder()
    
//    func sendRequest(_ request: RequestBase, completion: @escaping (User) -> Void) {
//        let headers: HTTPHeaders = []
//        AF.request(request.url, method: getMethodOfRequest(request), parameters: getMethodOfRequest(request) == .post ? request.parameters : nil, encoding: JSONEncoding.default, headers: headers).responseData { response in
//            switch response.result {
//            case .success(let data):
//                do {
//                    let responseJson = try User(data: data)
//                    completion(responseJson)
//                } catch let err {
//                    print("error: \(err)")
//                }
//            case .failure(let err ):
//                print("error: \(err)")
//                break
//            }
//        }
//    }
//
//    func getMethodOfRequest(_ reqest:RequestBase) -> HTTPMethod {
//        switch reqest.method {
//        case .get:
//            return .get
//        case .post:
//            return .post
//        case .put:
//            return .put
//        case .delete:
//            return .delete
//        }
//    }
//
//    func isShowLoader(_ isShowed : Bool) {
//        if isShowed{
//            SVProgressHUD.setDefaultMaskType(.black)
//            SVProgressHUD.setBackgroundColor(UIColor.white)
//            SVProgressHUD.show()
//        }else{
//            SVProgressHUD.dismiss()
//        }
//    }
//}

class APIService {
    
    static func fetchUsers(completion : @escaping (Result<[User], Error>) -> ()) {
        let sourcesURL = URL(string: "https://api.github.com/users?since=0")!
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode([User].self, from: data)
                completion(.success(empData))
        }.resume()
    }
    
    static func fetchUserDetails(user: String, completion : @escaping (Result<UserDetails, Error>) -> ()) {
        let sourcesURL = URL(string: "https://api.github.com/users/" + user)!
        URLSession.shared.dataTask(with: sourcesURL) { (data, urlResponse, error) in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
                let jsonDecoder = JSONDecoder()
                let empData = try! jsonDecoder.decode(UserDetails.self, from: data)
                completion(.success(empData))
        }.resume()
    }
}
