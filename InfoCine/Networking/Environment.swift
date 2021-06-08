
import Foundation

enum Server {
    case developement
}


class Environment {
    
    static let server:Server = .developement
    
    class func APIBaseURL() -> String {
        switch self.server {
        case .developement:
            return "https://ba-api.lpnt.fr"
        }
    }
    
    static func urlType(_ type: APIRouter, limit:Int, offset: Int, idPeron:Int, idFilm: Int) -> URL? {
        let baseURL:String = {
            return Environment.APIBaseURL()
        }()
        
        let relativePath: String? = {
            switch type {
            case .home:
                return "/rubrique/home/limit/\(limit)/offset/\(offset)"
            case .actors:
                return "/rubrique/acteurs/limit/\(limit)/offset/\(offset)"
            case .directors:
                return "/rubrique/directeurs/limit/\(limit)/offset/\(offset)"
            case .producers:
                return "/rubrique/producteurs/limit/\(limit)/offset/\(offset)"
            case .person:
                return "/personne/\(idPeron)"
            case .imagesPerson:
                return "/public/images/personne/\(idPeron)"
            case .imagesFilm:
                return "/public/images/film/\(idFilm)"
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
