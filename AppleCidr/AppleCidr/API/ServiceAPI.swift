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
    let headers = HTTPHeaders([.init(name: "token", value: "64f073ac2084f64f073ac20851")])

    func news() async -> News? {
        guard let url = URL(string: baseUrl + "/news/LatestNews") else { return nil } //.failure(.empty) }
        var request = URLRequest(url: url)
        request.headers = headers
        let response = await AF.request(url)
            .serializingDecodable(News.self)
            .response

        return response.value
    }

    func news1Minute() async -> [News] {
        var request = URLRequest(url: .init(string: baseUrl + "/news/LatestNews1Minute")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([News].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func news5Minutes() async -> [News]{
        var request = URLRequest(url: .init(string: baseUrl + "/news/LatestNews5Minutes")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([News].self)
            .response
        if let value = response.value {
            return value
        }

        return []
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
