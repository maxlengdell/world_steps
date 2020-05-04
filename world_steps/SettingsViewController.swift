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
    
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var strideLength: UILabel!
    @IBOutlet weak var textInput: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //Read from core data and present current stride length
        updateLabel()
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
    func readData() -> [Any] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            //Will only return the last read value
            /*for data in result as! [NSManagedObject] {
                print(data.value(forKey: "stridelength") as! Int)
                //returnVar = data.value(forKey: "stridelength") as! Int
            }*/
            return result
            
        } catch {
            print(error)
            return []
        }
        
    }
    func updateLabel() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            //Will only return the last read value
            for data in result as! [NSManagedObject] {
                strideLength.text =  String(data.value(forKey: "stridelength") as! Int) + " cm"
                stepper.value = Double(data.value(forKey: "stridelength") as! Int)
            }
            
            
        } catch {
            print(error)
            
        }
    }
    func updateData(_ length: Int) {
/*
         if readData = nil
            create default
         else
            update given data
         
         */
        if (readData().isEmpty) {
            /*
             Creating default value to 100 cm in stride length
             */
            print("Creating default value")
            createData(length: 100)
        }
        else {
            /*
             Stride length is already set. Just update the given value
             */
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "stridelength > 0")
            fetchRequest.fetchLimit = 1
            do {
                let test = try context.fetch(fetchRequest)
                let update = test[0] as! NSManagedObject
                update.setValue(length, forKey: "stridelength")
                try context.save()
                
            }catch {
                print(error)
            }
        }
        
    }
    
    @IBAction func readAllData(_ sender: Any) {
        print("Reading: \(readData())")
    }
    @IBAction func updateStrideLength(_ sender: UIStepper) {
        /*
         Update data.
         Update label
         */
        let lengthVar = Int(sender.value)
        updateData(lengthVar)
        updateLabel()
        
        //Update button
        //strideLength.text = String(readData())

    }
    @IBAction func uploadAction(_ sender: Any) {
        
    }
    
    
}
//https://dev.to/maeganwilson_/how-to-make-a-task-list-using-swiftui-and-core-data-513a
