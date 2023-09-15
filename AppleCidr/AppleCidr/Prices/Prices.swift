//
//  Prices.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation

final class Prices {
    
    func bidsPrint(bids: [CompanyBids]) {
        
        for bid in bids.sorted { $0.id < $1.id } {
            if bid.bids.count > 0 {
                print("\n\(bid.id)  \(bid.ticker)")
                bid.bids.forEach({
                    print("  \($0.price)  \($0.quantity)")
                })
            }
        }
    }
    
    func bidsByNews() {
        Task {
            let news = await ServiceAPI().news()
            print("News: \(news)")
            let tickers = news?.companiesAffected ?? []

            Task {
                let buy = await ServiceAPI().getBuyBids()
                let bids = buy.filter { stock in
                    let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                    return tickers.contains(ticker)
                }
                print("\nBuys:")
                bidsPrint(bids: bids)
            }

            Task {
                let sell = await ServiceAPI().getSellBids()
                let bids = sell
                    .filter { stock in
                        stock.bids.count > 0
                    }
                    .filter { stock in
                        let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                        return tickers.contains(ticker)
                    }

                print("\nSell:")
                bidsPrint(bids: bids)
            }
        }
    }
}
