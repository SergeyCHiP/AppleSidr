//
//  Prices.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation

final class Prices {
    func bidsByNews() {
        Task {
            let news = await ServiceAPI().news()
            print("News: \(news)")
            let tickers = news?.companiesAffected ?? []

            Task {
                let buy = await ServiceAPI().buyStock()
                let bids = buy.filter { stock in
                    let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                    return tickers.contains(ticker)
                }
                print("Buy:")
                for bid in bids {
                    print(bid)
                }
            }

            Task {
                let sell = await ServiceAPI().sellStock()
                let bids = sell.filter { stock in
                    let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                    return tickers.contains(ticker)
                }

                print("Sell:")
                for bid in bids {
                    print(bid)
                }
            }
        }
    }
}
