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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        presentSignUpScreen()
//        NetworkManager().saveMeal(meal: Meal(name: "hello", photo: nil, rating: 3, cal: 100, mealDescription: "love it", id: 1, userid: 22)!) { (err) -> (Void) in
//            print(err)
//        }
        
        if let savedMeals = loadMeals() {
            meals += savedMeals
        } else {
            loadSampleMeals()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if !hasSignedUp() {
            
        }
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
                fatalError("Unexpected sender: \(sender)")
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
                
                
            }
            
            saveMeals()
            
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }
    
    //MARK: PRIVATES

    private func loadSampleMeals() {
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal1")
        
//        guard let meal1 = Meal(name: "meal1", photo: photo1, rating: 4) else {
//            fatalError("unable to ...")
//        }
//        guard let meal2 = Meal(name: "meal1", photo: photo2, rating: 3) else {
//            fatalError("unable to ...")
//        }
        
//        meals += [meal1, meal2]
        
    }
    
    private func saveMeals() {
        
        do {
            let data = try? NSKeyedArchiver.archivedData(withRootObject: meals, requiringSecureCoding: false)
            if let data = data {
                try data.write(to: Meal.archiveURL)
            }
            
        } catch let error {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
            print(error)
        }
        
        os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        
    }
    
    private func loadMeals() -> [Meal]? {
        
        guard let data = try? Data(contentsOf: Meal.archiveURL) else {
            return nil
        }
        
        guard let meals = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Meal] else {
            return nil
        }
        return meals
        
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
    
    // Override to support conditional editing of the table view.
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    
    
}
