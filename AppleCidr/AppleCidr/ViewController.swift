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

        Task {
            let some = await ServiceAPI().news1Minute()
            print("\(some)")
        }
    }

}

