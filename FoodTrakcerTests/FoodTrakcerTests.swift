//
//  FoodTrakcerTests.swift
//  FoodTrakcerTests
//
//  Created by Dayson Dong on 2019-06-08.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

import XCTest
@testable import FoodTrakcer

class FoodTrakcerTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: test meal class
    
    func test_mealInitializationSucceeds() {
        
        let zeroRatingMeal = Meal(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        let positiveRatingMeal = Meal(name: "positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    func test_mealInitializationFails() {
        
        let negativeRatingMeal = Meal(name: "negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        let emptyStringMeal = Meal(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
        let largeRatingMeal = Meal(name: "large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
    }
}
