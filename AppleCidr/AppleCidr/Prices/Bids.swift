//
//  Bids.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation

final class Bids {

    func bids(by id: Int) {
        Task {
            let buy = await ServiceAPI().getBuyBids()
            let companies = buy.filter { stock in
//                let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                return stock.id == id
            }
            print("Buy:")
            for company in companies {
                for bid in company.bids {
                    print(bid)
                }
            }
        }

        Task {
            let sell = await ServiceAPI().getSellBids()
            let companies = sell
//                .filter { stock in
//                    stock.bids.filter({ $0.price < bidprice }).count > 0
//                }
                .filter { stock in
//                    let ticker = stock.ticker.replacingOccurrences(of: "Oranges/", with: "")
                    return stock.id == id
                }

            print("Sell:")
            for company in companies {
                for bid in company.bids {
                    print(bid)
                }
            }
        }
    }

}
