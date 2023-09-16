//
//  TicketStorage.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import Foundation

final class TicketStorage {

    static let shared: TicketStorage = TicketStorage()

    init() {}
    func setup() async {
        tickets = await ServiceAPI().getSymbols()

//        for index in 1...100 {
//            tickets.append(.init(id: index, ticker: "\(index)"))
//        }
    }

    private(set) var tickets: [GetSymbol] = []

    func id(by name: String) -> Int? {
        tickets.first(where: { $0.ticker == "Oranges/\(name)"} )?.id
    }
}
