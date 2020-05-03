//
//  SettingsViewController.swift
//  world_steps
//
//  Created by Max lengdell on 2020-05-03.
//  Copyright © 2020 Max lengdell. All rights reserved.
//

import UIKit
import CoreData
import Foundation
let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext
class SettingsViewController: UIViewController {
    
    @IBOutlet weak var strideLength: UILabel!
    @IBOutlet weak var textInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //createData(length: 100)
        //Read from core data and present current stride length
        strideLength.text = String(readData())
    }
    func createData(length: Int) {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(length, forKey: "stridelength")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
    }
    func readData() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        var length = 0
        var returnVar = 0
        do {
            let result = try context.fetch(request)
            //Will only return the last read value
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "stridelength") as! Int)
                returnVar = data.value(forKey: "stridelength") as! Int
            }
            print(result)
            
        } catch {
            print("Failed")
        }
        return returnVar
    }
    func updateData(_ length: Int) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "stridelength > 0")
        fetchRequest.fetchLimit = 1
        do {
            let test = try context.fetch(fetchRequest)
            let update = test[0] as! NSManagedObject
            update.setValue(length, forKey: "stridelength")
        }catch {
            print(error)
        }
    }
    @IBAction func updateStrideLength(_ sender: UIStepper) {
        let lengthVar = Int(sender.value)
        /*
         Update data.
         
         */
        updateData(lengthVar)
        
        
        //Update button
        strideLength.text = String(readData())

    }
    @IBAction func uploadAction(_ sender: Any) {
        print("read: \(readData())")

    }
    
}
//https://dev.to/maeganwilson_/how-to-make-a-task-list-using-swiftui-and-core-data-513a
