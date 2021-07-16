//
//  Entity.swift
//  Movie_RX
//
//  Created by Thân Văn Thanh on 09/07/2021.
//

import Foundation
import RxSwift

struct Movie : Codable {

        let response : String?
        let search : [MovieSearch]?
        let totalResults : String?

        enum CodingKeys: String, CodingKey {
                case response = "Response"
                case search = "Search"
                case totalResults = "totalResults"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                response = try values.decodeIfPresent(String.self, forKey: .response)
                search = try values.decodeIfPresent([MovieSearch].self, forKey: .search)
                totalResults = try values.decodeIfPresent(String.self, forKey: .totalResults)
        }

}
struct MovieSearch : Codable {

        let imdbID : String?
        let poster : String?
        let title : String?
        let type : String?
        let year : String?

        enum CodingKeys: String, CodingKey {
                case imdbID = "imdbID"
                case poster = "Poster"
                case title = "Title"
                case type = "Type"
                case year = "Year"
        }
    
        init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                imdbID = try values.decodeIfPresent(String.self, forKey: .imdbID)
                poster = try values.decodeIfPresent(String.self, forKey: .poster)
                title = try values.decodeIfPresent(String.self, forKey: .title)
                type = try values.decodeIfPresent(String.self, forKey: .type)
                year = try values.decodeIfPresent(String.self, forKey: .year)
        }

}



//struct Movie : Codable{
//    var totalResults : String?
//    var Response : String?
//    var search : [Search]?
//
//    private enum Codingkeys : String , CodingKey {
//     case totalResults
//        case Response
//        case results
//    }
//}
//
//struct Search : Codable {
//    var title : String
////    var Year : String
////    var imdbID : String
//    var Poster : String
//
//    private enum Codingkeys : String , CodingKey {
//        case Title
//        case Year
//        case imdbID
//        case Poster
//    }
//
//}
//
