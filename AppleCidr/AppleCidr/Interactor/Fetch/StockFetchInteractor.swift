//
//  NewsFetchInteractor.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/16/23.
//

import Foundation

actor StockStorage {
    private var oranges: Int = 0
    private var stocks: [InfoResponse.Asset] = []

    func store(stocks: [InfoResponse.Asset]) {
        self.stocks = stocks.filter({ asset in
            if asset.name == "Oranges" {
                self.oranges = asset.quantity
                return false
            }
            return asset.quantity > 0
        })
    }

    func stocksList() -> [InfoResponse.Asset] {
        self.stocks
    }

    func orangesAmount() -> Int {
        self.oranges
    }
}

final class StockFetchInteractor {

    static let shared = StockFetchInteractor()

    private(set) var storage = StockStorage()

    init() {
        Task {
            while true {
                if let info = await ServiceAPI().info() {
                    await storage.store(stocks: info.assets)
                }
                await print(storage.orangesAmount())

                let stockList = await storage.stocksList()
//                print(stockList)
                for stock in stockList {
                    if let id = TicketStorage.shared.id(by: stock.name) {
                        let price = Int.random(in: 100...1000)
                        print("Sell: \(stock.name) \(id) \(price)")
                        await ServiceAPI().limitPriceSell(id: id, price: price, quantity: 1)
                    }
                }
                try? await Task.sleep(seconds: 3)
            }
        }
    }
}
