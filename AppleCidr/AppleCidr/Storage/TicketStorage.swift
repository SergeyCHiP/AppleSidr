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

    var tickets: [GetSymbol] = []

}
