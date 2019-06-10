//
//  NetworkManager.swift
//  FoodTrakcer
//
//  Created by Dayson Dong on 2019-06-10.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    private func makeURL(withEndpoint endpoint: String) -> URL? {
        
        var urlComponents = URLComponents.init()
        urlComponents.scheme = "https"
        urlComponents.host = "cloud-tracker.herokuapp.com"
        urlComponents.path = endpoint
        
        return urlComponents.url
        
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
        let token = UserDefaults.standard.string(forKey: "token")!
        
        request.httpBody = postJSON
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(token, forHTTPHeaderField: "token")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            print("data: \(data)")
            completion(error)
            
        }
        
        task.resume()

        
    }

}
