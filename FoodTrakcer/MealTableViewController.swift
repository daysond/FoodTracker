//
//  MealTableViewController.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-09.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    
    var meals = [Meal]()
    var networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        loadMeals()
        presentSignUpScreen()

    }
    
    
    //MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
            
        default:
            fatalError("Unexpexted segue id")
        }
        
    }
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceVC = sender.source as? MealViewController, let meal = sourceVC.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                //TODO: SAVE MEAL HERE AND PAUSE SCREEN

            }
            
            saveMeals()
            
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    //MARK: PRIVATES
    
    private func saveMeals() {
        
//        do {
//            let data = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
//            if let data = data {
//                try data.write(to: Meal.archiveURL)
//            }
//
//        } catch let error {
//            os_log("Failed to save meals...", log: OSLog.default, type: .error)
//            print(error)
//        }
//
//        os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        
    }
    
    private func loadMeals() {
        
        networkManager.getAllMeals { (data) -> (Void) in
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) else {
                print("data not valid")
                return
            }
            
            guard let results = json as? [[String : Any]] else {
                print("could not parsed json")
                return
            }
            
            for result in results {
                
                if let meal = Meal(name: result["title"] as! String, photo: nil, rating: result["rating"] as! Int, cal: result["calories"] as! Int, mealDescription: result["description"] as! String, id: result["id"] as! Int, userid: result["user_id"] as! Int) {
                    self.meals.append(meal)
                }
            }
            
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    private func hasSignedUp() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasSignedUp")
    }
    
    private func presentSignUpScreen() {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let signupScreen = storyboard.instantiateViewController(withIdentifier: "SignupScreen") as! SignupViewController
        self.present(signupScreen, animated: true, completion: nil)
        
    }
    
    //MARK: TABLE VIEW DELEGATES
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MealTableViewCell else {
            fatalError("Error")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.photoImageView.image = meal.photo
        cell.ratingControl.rating = meal.rating
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    
    
}
