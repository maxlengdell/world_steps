//
//  HKParser.swift
//  world_steps
//
//  Created by Max lengdell on 2020-05-02.
//  Copyright © 2020 Max lengdell. All rights reserved.
//

import Foundation
import UIKit
import HealthKit

func getStepsMonth(completion: @escaping (Double) -> Void)
{
    let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let now = Date()
    var interval = DateComponents()
    interval.day = 31
    var dateComponents = DateComponents()
    dateComponents.setValue(-30, for: .day);
    let startOfCount = Calendar.current.date(byAdding: dateComponents, to: now)
    let startOfStart = Calendar.current.startOfDay(for: startOfCount!)

    let query = HKStatisticsCollectionQuery(quantityType: type,
                                            quantitySamplePredicate: nil,
                                            options: [.cumulativeSum],
                                            anchorDate: startOfStart,
                                            intervalComponents: interval)
    query.initialResultsHandler = { _, result, error in
        var resultCount = 0.0
        result?.enumerateStatistics(from: startOfStart, to: now) { statistics, _ in
            
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
func getStepsWeek(completion: @escaping (Double) -> Void)
{
    let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let now = Date()
    var interval = DateComponents()
    interval.day = 8
    var dateComponents = DateComponents()
    dateComponents.setValue(-7, for: .day);
    let startOfCount = Calendar.current.date(byAdding: dateComponents, to: now)
    let startOfStart = Calendar.current.startOfDay(for: startOfCount!)

    let query = HKStatisticsCollectionQuery(quantityType: type,
                                            quantitySamplePredicate: nil,
                                            options: [.cumulativeSum],
                                            anchorDate: startOfStart,
                                            intervalComponents: interval)
    query.initialResultsHandler = { _, result, error in
        var resultCount = 0.0
        result?.enumerateStatistics(from: startOfStart, to: now) { statistics, _ in
            
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
func getStepsDay(completion: @escaping (Double) -> Void)
{
    let type = HKQuantityType.quantityType(forIdentifier: .stepCount)!
    let now = Date()
    var interval = DateComponents()
    interval.day = 1
    let startOfStart = Calendar.current.startOfDay(for: now)
    
    let query = HKStatisticsCollectionQuery(quantityType: type,
                                            quantitySamplePredicate: nil,
                                            options: [.cumulativeSum],
                                            anchorDate: startOfStart,
                                            intervalComponents: interval)
    query.initialResultsHandler = { _, result, error in
        var resultCount = 0.0
        result?.enumerateStatistics(from: startOfStart, to: now) { statistics, _ in
            
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
