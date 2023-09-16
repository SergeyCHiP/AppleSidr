//
//  PriceInteractor.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/16/23.
//

import Foundation

actor PriceStorage {
    private var price: [String: Int] = [:]

    func store(company: String, price: Int) {
        self.price[company] = price
    }

    func price(company: String) -> Int? {
        self.price[company]
    }
}

final class PriceInteractor {

    static let shared = PriceInteractor()

    private(set) var storage: PriceStorage = .init()

    init() {
        Task {
            while true {
                for company in TicketStorage.shared.tickets {
                    let ticker = company.ticker.replacingOccurrences(of: "Oranges/", with: "")
                    let sellBid = SellBidsFetchInteractor.shared.bids[ticker]?.bids.first
                    let buyBid = BuyBidsFetchInteractor.shared.bids[ticker]?.bids.first

                    switch (sellBid, buyBid) {
                    case (.some(let sellBid), .some(let buyBid)):
                        await storage.store(company: ticker, price: Int(Double(sellBid.price + buyBid.price)/2))
                    case (.some(let sellBid), nil):
                        await storage.store(company: ticker, price: sellBid.price)
                    case (nil, .some(let buyBid)):
                        await storage.store(company: ticker, price: buyBid.price)
                    case (nil, nil):
                        await storage.store(company: ticker, price: -1)
                    }
                }
                try? await Task.sleep(seconds: 1)
            }
        }
    }

}
