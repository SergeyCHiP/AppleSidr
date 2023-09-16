//
//  BuyBidsFetchInteractor.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/16/23.
//

import Foundation

final class BuyBidsFetchInteractor {

    static let shared = BuyBidsFetchInteractor()
    private(set) var bids: [String: CompanyBids] = [:]

    init() {
        Task {
            while true {
                var bids: [String: CompanyBids] = [:]
                let companies = await ServiceAPI().getBuyBids()
//                var companies = [CompanyBids]()
//                for index in 1...100 {
//                    var bids = [BidStat]()
//                    for _ in 0...Int.random(in: 0...3) {
//                        let bid = BidStat(price: .random(in: 0...40000), quantity: .random(in: 0...1000))
//                        bids.append(bid)
//                    }
//                    let company = CompanyBids(id: index, ticker: "\(index)", bids: bids)
//                    companies.append(company)
//                }


                for company in companies {
                    bids[company.ticker] = CompanyBids(id: company.id, ticker: company.ticker, bids: company.bids.sorted(by: { left, right in
                        left.price > right.price
                    }))
                }
                self.bids = bids
                try? await Task.sleep(seconds: 0.01)
            }
        }
    }
}
