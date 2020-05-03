//
//  ViewController.swift
//  world_steps
//
//  Created by Max lengdell on 2020-05-01.
//  Copyright © 2020 Max lengdell. All rights reserved.
//

import UIKit
import HealthKit
let healthStore = HKHealthStore()
class ViewController: UIViewController {
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var stepsLabelWeek: UILabel!
    @IBOutlet weak var stepsLabelDay: UILabel!
    
    fileprivate func extractedFunc() {
        // Authorization Successful
        
        getStepsMonth { (result) in
            DispatchQueue.main.async {
                let stepCount = String(Int(result))
                self.stepsLabel.text = String(stepCount)
                print("steps month: \(stepCount)");
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Access Step Count
        authorize()
        extractedFunc()
        getStepsWeek { (result) in
            DispatchQueue.main.async {
                let stepCount1 = String(Int(result))
                self.stepsLabelWeek.text = String(stepCount1)
                print("steps week: \(stepCount1)");
                
            }
        }
        getStepsDay { (result) in
            DispatchQueue.main.async {
                let stepCount = String(Int(result))
                self.stepsLabelDay.text = String(stepCount)
                print("steps a Day: \(stepCount)");
                
            }
        }
    }
    
    @IBAction func update(_ sender: Any) {
        print("test")
        
        getStepsMonth { (result) in
            DispatchQueue.main.async {
                let stepCount = String(Int(result))
                self.stepsLabel.text = String(stepCount)
                print("steps month: \(stepCount)");
                
            }
        }
        getStepsWeek { (result) in
            DispatchQueue.main.async {
                let stepCount1 = String(Int(result))
                self.stepsLabelWeek.text = String(stepCount1)
                print("steps week: \(stepCount1)");
                
            }
        }
        getStepsDay { (result) in
            DispatchQueue.main.async {
                let stepCount = String(Int(result))
                self.stepsLabelDay.text = String(stepCount)
                print("steps a Day: \(stepCount)");
                
            }
        }
    }
}

