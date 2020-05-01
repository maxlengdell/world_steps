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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Access Step Count
        authorize()
        // Authorization Successful
        self.getSteps { (result) in
            DispatchQueue.main.async {
                let stepCount = String(Int(result))
                self.stepsLabel.text = String(stepCount)
            }
        }
        
    }
    func authorize(){
        let writableTypes: Set<HKSampleType> =
                  [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]
              let readableTypes: Set<HKSampleType> = [HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!]

              guard HKHealthStore.isHealthDataAvailable() else {
                  print("false on availability");
                  return
              }
              //let healthKitTypes: Set = [ HKObjectType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount)! ]
              //Check for authorization
              healthStore.requestAuthorization(toShare: writableTypes, read: readableTypes) { (success, error) in
                  if (success) {
                      //Authorization successful
                      print("Authenticated");
                  }
              }
              // Do any additional setup after loading the view.
          }
    
    func getSteps(completion: @escaping (Double) -> Void)
    {
  let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
      
  let now = Date()
  let startOfDay = Calendar.current.startOfDay(for: now)
  var interval = DateComponents()
  interval.day = 1
        let query = HKStatisticsCollectionQuery(quantityType: type,
  quantitySamplePredicate: nil,
  options: [.cumulativeSum],
  anchorDate: startOfDay,
  intervalComponents: interval)
        query.initialResultsHandler = { _, result, error in
                var resultCount = 0.0
                result!.enumerateStatistics(from: startOfDay, to: now) { statistics, _ in

                if let sum = statistics.sumQuantity() {
                    // Get steps (they are of double type)
                    resultCount = sum.doubleValue(for: HKUnit.count())
                } // end if

                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            }
        }
        query.statisticsUpdateHandler = {
            query, statistics, statisticsCollection, error in

            // If new statistics are available
            if let sum = statistics?.sumQuantity() {
                let resultCount = sum.doubleValue(for: HKUnit.count())
                // Return
                DispatchQueue.main.async {
                    completion(resultCount)
                }
            } // end if
        }
        healthStore.execute(query)
}
    /*
    func readSteps(completion: (_ stepsRetrieved: Double) -> Void) {
        //Define quantity of data
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)
        let date = Date()
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date)
        let startOfDay = Calendar.current.startOfDay(for: Date())

        //Set predicates & Interval
        let predicate = HKQuery.predicateForSamples(withStart: newDate, end: date, options: .strictStartDate)
        var interval = DateComponents()
        interval.day = 1
        
        //Perform query
        let query = HKStatisticsCollectionQuery(quantityType: stepsCount!, quantitySamplePredicate: predicate, options: [.cumulativeSum], anchorDate: newDate as Date, intervalComponents: interval)
        
        query.initialResultsHandler = { query, results, error in
            if error != nil {
                //Something went wrong
                return
            }
            
                if let myResults = results{
                myResults.enumerateStatistics(from: startOfDay, to: date) {
                    statistics, stop in
                    
                    if let quantity = statistics.sumQuantity() {

                                           let steps = quantity.doubleValue(for: HKUnit.count())

                                           print("Steps = \(steps)")
                                           completion(stepRetrieved: steps)
                    }
                }
            }
        }
        healthStore.execute(query)
    }*/
}

