
import Foundation

enum Server {
    case developement
}


class Environment {
    
    static let server:Server = .developement
    
    class func APIBasePath() -> String {
        switch self.server {
        case .developement:
            return "https://ba-api.lpnt.fr"
        }
    }
    
    static func urlType(_ type: APIRouter, limit:Int, offset: Int) -> URL? {
        let baseURL:String = {
            return Environment.APIBasePath()
        }()
        
        let relativePath: String? = {
            switch type {
            case .home:
                return "/rubrique/home/limit/\(limit)/offset/\(offset)"
            case .actors:
                return "/rubrique/acteurs/limit/2/offset/6"
            case .directors:
                return "/rubrique/directeurs/limit/2/offset/6"
            case .producers:
                return "/rubrique/producteurs/limit/2/offset/6"
            case .person:
                return "/personne/3020"
            }
        }()
        
        if let url = URL(string: baseURL) {
            if let relativePath = relativePath {
                return url.appendingPathComponent(relativePath)
            }
        }
        return nil
    }
    
}
