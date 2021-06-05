import Foundation
import Alamofire

class API {
    
    static let shared:API = {
        let instance = API()
        return instance
    }()
    
    init() {}
    
    enum NetworkingResult {
        case fail(Data)
        case success(Data)
    }

    
//    class func headers() -> HTTPHeaders {
//        var headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//            "Accept": "application/json"
//        ]
//
//        if let authToken = UserDefaults.standard.string(forKey: "auth_token") {
//            headers["Authorization"] = "Bearer" + " " + authToken
//        }
//
//        return headers
//    }
    
    func service(from data: Dictionary<String, Int>, router : APIRouter, _ completion: @escaping (NetworkingResult) -> Void) {
        guard let page =  data["limit"]  else { return }
        guard let offset = data["offset"] else { return }

        guard let url = Environment.urlType(router, limit:page ,offset:offset) else {return}

    
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response  in
                 switch response.response?.statusCode {
                 case 200: completion(.success(response.data!))
                 default: completion(.fail(response.data!))
              }
            }
    }

    
}
