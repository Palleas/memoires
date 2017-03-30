//
//  ViewController.swift
//  Memoires
//
//  Created by Romain Pouclet on 2017-03-28.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Result

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer(interval: .seconds(1), on: QueueScheduler())
            .startWithValues { date in
                print("Tick! (\(date))")
            }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

