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
    let headers = HTTPHeaders([
        .init(name: "token", value: "64f073ac2084f64f073ac20851")
    ])

    let headersPost = HTTPHeaders([
        .init(name: "token", value: "64f073ac2084f64f073ac20851"),
        .init(name: "Content-Type", value: "application/json")
    ])

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

    func getSellBids() async -> [CompanyBids] {
        var request = URLRequest(url: .init(string: baseUrl + "/sellStock")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([CompanyBids].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func getBuyBids() async -> [CompanyBids] {
        var request = URLRequest(url: .init(string: baseUrl + "/buyStock")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable([CompanyBids].self)
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

    func limitPriceBuy(id: Int, price: Int, quantity: Int) async -> [PostBidResult] {
        let url = URL(string: baseUrl + "/LimitPriceBuy")!
        var parameters = Parameters()
        parameters["symbolId"] = id
        parameters["price"] = price
        parameters["quantity"] = quantity

        print(parameters)
        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersPost)
            .serializingDecodable([PostBidResult].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func limitPriceSell(id: Int, price: Int, quantity: Int) async -> [PostBidResult] {
        let url = URL(string: baseUrl + "/LimitPriceSell")!
        var parameters = Parameters()
        parameters["symbolId"] = id
        parameters["price"] = price
        parameters["quantity"] = quantity

        let response = await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersPost)
            .serializingDecodable([PostBidResult].self)
            .response
        if let value = response.value {
            return value
        }

        return []
    }

    func cancelOrder(id: Int) async -> Bool {
        let url = URL(string: baseUrl + "/LimitPriceBuy")!
        var parameters = Parameters()
        parameters["bidId"] = id

        let response = await AF.request(url, method: .post, parameters: parameters, headers: headersPost)
            .serializingDecodable([PostBidResult].self)
            .response

        return response.response?.statusCode == 200
    }

    func info() async -> InfoResponse? {
        var request = URLRequest(url: .init(string: baseUrl + "/info")!)
        request.headers = headers
        let response = await AF.request(request)
            .serializingDecodable(InfoResponse.self)
            .response
        return response.value
    }

    func showInfo() async {
        let some = await ServiceAPI().info()
        print("\(some!.account.id)\n \(some!.account.name)")
        print("\nBids:\n\n\(some!.bids)\n\nAssets:\n")

        for asset in some!.assets {
            let assetInfo = "\(asset.id)" + " \(asset.name)" + " \(asset.quantity)"
            print(assetInfo)
        }
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
    let price: Int
    let quantity: Int32
}

struct PostBidResult: Decodable {
    let bidId: Int64
}

struct CompanyBids: Decodable {
    let id: Int
    let ticker: String
    let bids: [BidStat]
}

struct GetSymbol: Decodable {
    let id: Int
    let ticker: String
}

struct InfoResponse: Decodable {
    struct Account: Decodable {
        let id: Int
        let name: String
    }
    struct Bid: Decodable {
        let id: Int
        let symbolId: Int
        let price: Int
        let type: String
        let createDate: String
    }
    struct Asset: Decodable {
        let id: Int
        let name: String
        let quantity: Int
    }

    let account: Account
    let bids: [Bid]
    let assets: [Asset]
}
