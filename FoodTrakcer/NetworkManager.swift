//
//  NetworkManager.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-10.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    let token = UserDefaults.standard.string(forKey: "token")!
    
    //MARK: HELPERS
    
    func parseJSONData(data: Data?) -> [String: Any]? {
        
        guard let data = data else {
            print("data error")
            return nil
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
            print("data not valid")
            return nil
        }
        
        guard let result = json as? [String: Any] else {
            print("could not parsed json")
            return nil
        }
        
        return result
        
    }
    

    
    func post(data: [String: Any], toEndpoint endpoint: String, completion: @escaping (Data?, URLResponse?, Error?) -> (Void)) {
        
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            print("Could not serialize json")
            return
        }
        
        guard let url = makeURL(withEndpoint: endpoint) else {
            return
        }
        
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            completion(data, response,error)
            
        }
        
        task.resume()
      
    }
    
    
    
    func saveMeal(meal: Meal, completion: @escaping (Error?) -> (Void)) {
        
        let data = ["title": meal.name, "calories": meal.calories, "description": meal.mealDescription] as [String : Any]
        let endpoint = "/users/me/meals"
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            print("Could not serialize json")
            return
        }
        
        guard let url = makeURL(withEndpoint: endpoint) else {
            return
        }
        
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            print("meal uploading")
            guard let response = response as? HTTPURLResponse else {
                print("response error")
                return
            }
            
            guard response.statusCode == 200 else {
                print("status code: \(response.statusCode)")
                return
            }
            // Parse JSON to get meal id and user id
            guard let mealInfo = self.parseJSONData(data: data)  else {
                return
            }
            
            guard let mealDict:[String: Any] = mealInfo["meal"] as? Dictionary else {
                return
            }
            
            // post rating to meal with meal ID
            let mealID = mealDict["id"] as! Int
            let ratingData = ["rating": meal.rating]
            let ratingEndpoint = "/users/me/meals/\(mealID)/rate"
            
            self.postMealRating(ratingData, toEndpoint: ratingEndpoint, completion: { (data,error) -> (Void) in
                print("meal uploaded")
                guard let mealInfo = self.parseJSONData(data: data)  else {
                    return
                }
                
                guard let mealDict:[String: Any] = mealInfo["meal"] as? Dictionary else {
                    return
                }
                
                //TODO: update meal object here
                
                
                completion(error)
            })
            
        }
        
        task.resume()

    }
    
    func getAllMeals(completion: @escaping (Data?) -> (Void)) {
        
        let endpoint = "/users/me/meals"
        guard let url = makeURL(withEndpoint: endpoint) else {
            return
        }
        
        let request = NSMutableURLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard error == nil else {
                print("error: \(String(describing: error))")
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("response error")
                return
            }
            
            guard response.statusCode == 200 else {
                print("status code: \(response.statusCode)")
                return
            }
            
            guard let data = data else {
                print("data error")
                return
            }
            
            
            completion(data)
            
        }
        
        task.resume()
        
        
        
        
    }
    
    //MARK: PRIVATES
    
    private func postMealRating(_ rating: [String: Any], toEndpoint endpoint: String, completion: @escaping (Data?,Error?) -> (Void)) {
        
        guard let postJSON = try? JSONSerialization.data(withJSONObject: rating, options: []) else {
            print("Could not serialize json")
            return
        }
        
        guard let url = makeURL(withEndpoint: endpoint) else {
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else {
                print("response error")
                return
            }
            
            guard response.statusCode == 200 else {
                print("status code: \(response.statusCode)")
                return
            }
            
            if error != nil {
                print("did not set rating")
            }
            
            completion(data,error)
           
        }
        
        task.resume()
        
    }
    
    private func makeURL(withEndpoint endpoint: String) -> URL? {
        
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = "cloud-tracker.herokuapp.com"
        urlComponents.path = endpoint
        
        return urlComponents.url
        
    }
    

    

}
