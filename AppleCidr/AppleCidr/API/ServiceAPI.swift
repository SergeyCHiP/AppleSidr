//
//  ServiceAPI.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation
import Alamofire

final class ServiceAPI {

    let baseUrl = "https://datsorange.devteam.games"
    let headers = HTTPHeaders(dictionaryLiteral: ("token", "64f073ac2084f64f073ac20851"))

    func news() async { //async -> Result<Void, CidrError> {

        guard let url = URL(string: baseUrl + "/news/LatestNews") else { return } //.failure(.empty) }
        var request = URLRequest(url: url)
        request.headers = headers
        let response = await AF.request(url)
            .serializingDecodable(News.self)
            .response

        debugPrint(response)
    }

}

enum CidrError {
    case empty
}

struct News: Decodable {
    let date: String
    let text: String
    let rate: Int
    let companiesAffected: [String]
}
