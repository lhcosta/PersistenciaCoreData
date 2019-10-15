//
//  ViewController.swift
//  PersistenciaCoreData
//
//  Created by Lucas Costa  on 22/07/19.
//  Copyright © 2019 LucasCosta. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var people : [NSManagedObject]!
    var managedContext : NSManagedObjectContext!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.people = [NSManagedObject]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addName(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Name", message: nil, preferredStyle: .alert)
        
        let save = UIAlertAction(title: "Save", style: .default) { (_) in
            
            guard let name = alert.textFields?[0].text else {return}
            guard let age = alert.textFields?[1].text else {return}
                
              self.save(name: name, age: Int(age)!)  
              self.tableView.reloadData()  
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField(configurationHandler: {(name) in 
            name.placeholder = "Name"
        })
        alert.addTextField(configurationHandler: {(age) in
            age.placeholder = "Age"
        })
        alert.addAction(save)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
}

//Data Source
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let person = people[indexPath.row]
        
        cell.textLabel?.text = person.value(forKey: "name") as? String
        
        return cell
    }    
}

//Core Data
extension ViewController {
    
    //INSERT INTO PERSON ...
    func save(name : String, age : Int) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: "Person", in: self.managedContext) else { return }
        
        let person = NSManagedObject(entity: entity, insertInto: self.managedContext)
        
        person.setValue(name, forKey: "name")   
        person.setValue(age, forKey: "age")
        
        do {
            try self.managedContext.save()
            self.people.append(person)
            print("Save succesfully")
            
        } catch let error as NSError {
            
            if error.code == NSValidationNumberTooSmallError || error.code == NSValidationNumberTooLargeError {
                print("Valores inteiros invalidos")
            }
            
        }
        
    }
    
    //SELECT * FROM PERSON
    func fetch() {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        do {
            let objects = try self.managedContext.fetch(fetchRequest)
            
            objects.forEach { (person) in
                self.people.append(person)
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
}

