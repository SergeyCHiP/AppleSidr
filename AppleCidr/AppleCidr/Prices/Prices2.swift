//
//  Prices.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation

final class Prices2 {
    func bidsByNews() {
        Task {
            let news = await ServiceAPI().news5Minutes()
//            print("News: \(news)")
            let tickers = news.filter({ $0.rate > 0 }).reduce([], { result, news in
                return result + news.companiesAffected
            })

//            Task {
//                let buy = await ServiceAPI().getBuyBids()
//                let bids = buy.filter { stock in
//                    let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
//                    return tickers.contains(ticker)
//                }
//                print("Buy:")
//                for bid in bids {
//                    print(bid)
//                }
//            }

            Task {
                let sell = await ServiceAPI().getSellBids()
                let companies = sell
                    .filter { stock in
                        stock.bids.filter({ $0.price < 100 }).count > 0
                    }
                    .filter { stock in
                        let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                        return tickers.contains(ticker)
                    }

                print("Sell:")
                for company in companies {
                    print(company.ticker)
                    let bids = company.bids.filter { $0.price < 100 }
                    for bid in bids {
                        print(bid)
                    }

                    Task {
                        let resultBuy = await ServiceAPI().limitPriceBuy(id: company.id, price: 100, quantity: 1)
                        print(resultBuy)

                        Task {
                            let resultSell = await ServiceAPI().limitPriceSell(id: company.id, price: 999, quantity: 1)
                            print(resultSell)
                        }
                    }
                }
            }
        }
    }
}
