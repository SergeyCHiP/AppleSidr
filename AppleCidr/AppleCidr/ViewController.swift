//
//  ViewController.swift
//  AppleCidr
//
//  Created by George Ovchinnikov on 9/15/23.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            await TicketStorage.shared.setup()

            let _ = SellBidsFetchInteractor.shared
            let _ = BuyBidsFetchInteractor.shared
            let _ = NewsFetchInteractor.shared
            let _ = StockFetchInteractor.shared

            let _ = PriceInteractor.shared
            let _ = NewsAffectInteractor.shared
        }
        

//        Task {
//            while true {
//
//                let resultSell = await ServiceAPI().limitPriceSell(id: 501, price: 270, quantity: 2)
//                print(resultSell)
//                sleep(60)
//            }
//        }
//        Task {
//            Bids().bids(by: 501)
//        }

        // Do any additional setup after loading the view.

//		Task {
//            await ChipController().start()
//        }
//
//        Task {
//            Prices2().bidsByNews()
//        }

//        Task {
//            let result = await ServiceAPI().getSymbols()
//            print(result)
//        }

//        Task {
//            let some = await ServiceAPI().getSymbols()
//            print("\(some)")
//        }
    }

}


extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
