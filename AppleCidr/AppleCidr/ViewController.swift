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
        // Do any additional setup after loading the view.

//        Task {
//            let tickets = await ServiceAPI().getSymbols()
//            TicketStorage.shared.tickets = tickets
//		}
		Task {
            await ChipController().start()
        }
//
//        Task {
//            Prices().bidsByNews()
//        }

//        Task {
//            await ServiceAPI().
//        }

//        Task {
//            let some = await ServiceAPI().getSymbols()
//            print("\(some)")
//        }
    }

}

