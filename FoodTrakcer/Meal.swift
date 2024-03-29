//
//  Meal.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-09.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject,NSCoding {
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        self.init(name: name, photo: photo, rating: rating, cal: 1000, mealDescription: "nil", id: 1, userid: 2)
        
        
        
    }
    
    
    var name: String
    var photo: UIImage?
    var rating: Int
    var calories: Int
    var mealDescription: String
    var id: Int?
    var userid: Int?
    
    static let documentDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let archiveURL = documentDirectory.appendingPathComponent("meals")
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
    init?(name: String, photo: UIImage?, rating: Int, cal: Int, mealDescription: String, id: Int?, userid: Int?) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        self.rating = rating
        self.calories = cal
        self.mealDescription = mealDescription
        self.id = id
        self.userid = userid
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
    }
    
    
    
}
