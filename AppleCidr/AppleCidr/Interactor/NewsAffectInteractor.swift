//
//  NewsAffectInteractor.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/16/23.
//

import Foundation

final class NewsAffectInteractor {

    static let shared = NewsAffectInteractor()
    private var news: [String: [Int]] = [:]

    init() {
        Task {
            while true {
                let newsList = await NewsFetchInteractor.shared.storage.newsList()
                for new in newsList {
                    var count: Double = 0
                    var summary: Double = 0
                    for company in new.companiesAffected {
                        guard let price = await PriceInteractor.shared.storage.price(company: company) else { continue }
                        count += 1
                        summary += Double(price)
                    }

                    let averagePrice = summary / count
                    guard !(averagePrice.isNaN || averagePrice.isInfinite) else {
                        continue
                    }
                    news[new.date] = (news[new.date] ?? []) + [Int(averagePrice)]

                    print("Date: \(new.date)")
                    print("Text: \(new.text)")
                    print("Rate: \(new.rate)")
                    let startPrice = news[new.date]?.first ?? -1
                    let currentPrice = news[new.date]?.last ?? -1
                    print("startPrice: \(startPrice)")
                    print("currentPrice: \(currentPrice)")
                    print("changes: \(Decimal(currentPrice)/Decimal(startPrice))")
                    print("\n")
                }

                for new in newsList {
                    for company in new.companiesAffected {
                        guard let price = await PriceInteractor.shared.storage.price(company: company) else { continue }
                        let maxPrice = 50
                        if price > 1 && price < maxPrice && new.rate > 20 {
                            if let id = TicketStorage.shared.id(by: company) {
//                                print("Buy: \(company) \(id) \(maxPrice)")
                                await ServiceAPI().limitPriceBuy(id: id, price: maxPrice, quantity: 1)
                            }
                        }

                        if price < 0 {
                            if let id = TicketStorage.shared.id(by: company) {
                                let price = 13
//                                print("Buy: \(company) \(id) \(price)")
                                await ServiceAPI().limitPriceBuy(id: id, price: price, quantity: 1)
                            }
                        }
                    }
                }
                try? await Task.sleep(seconds: 5)
            }
        }
    }

}
