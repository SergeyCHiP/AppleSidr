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

    func news5Minutes() async -> [News] {
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

    func sellStock() async -> [SellStockResponse] {
        var request = URLRequest(url: .init(string: baseUrl + "/sellStock")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([SellStockResponse].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func getSymbols() async -> [GetSymbol] {
        var request = URLRequest(url: .init(string: baseUrl + "/getSymbols")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([GetSymbol].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func buyStock() async -> [SellStockResponse] {
        var request = URLRequest(url: .init(string: baseUrl + "/buyStock")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([SellStockResponse].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func info() async -> InfoResponse? {
        var request = URLRequest(url: .init(string: baseUrl + "/info")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable(InfoResponse.self)
            .response
        return response.value
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

struct BidStat: Decodable {
    let price: Int64
    let quantity: Int32
}

struct SellStockResponse: Decodable {
    let id: Int64
    let ticker: String
    let bids: [BidStat]
}

struct GetSymbol: Decodable {
    let id: Int64
    let ticker: String
}

struct InfoResponse: Decodable {
    struct Account: Decodable {
        let id: Int64
        let name: String
    }
    struct Bid: Decodable {
        let id: Int64
        let symbolId: Int64
        let price: Int64
        let type: String
        let createDate: String
    }
    struct Asset: Decodable {
        let id: Int64
        let name: String
        let quantity: Int64
    }

    let account: Account
    let bids: [Bid]
    let assets: [Asset]
}
