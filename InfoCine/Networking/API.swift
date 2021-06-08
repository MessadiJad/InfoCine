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

    func service(from data: Dictionary<String, Int>, router : APIRouter, _ completion: @escaping (NetworkingResult) -> Void) {
        guard let page =  data["limit"]  else { return }
        guard let offset = data["offset"] else { return }

        guard let url = Environment.urlType(router, limit:page ,offset:offset, idPeron: 520, idFilm: 0) else {return}
    
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response  in
                print(response)
                 switch response.response?.statusCode {
                 case 200: completion(.success(response.data!))
                 default: completion(.fail(response.data ?? Data()))
              }
            }
    }
    
    
    
    
    
    func detailService(router : APIRouter, _ completion: @escaping (NetworkingResult) -> Void) {
     
        guard let url = Environment.urlType(router, limit:0 ,offset:0, idPeron: 520, idFilm: 0) else {return}
    
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response  in
                print(response)
                 switch response.response?.statusCode {
                 
                 case 200:
                    completion(.success(response.data!))
                    
                 default:
                    completion(.fail(response.data ?? Data()))
              }
            }
    }
    
}
