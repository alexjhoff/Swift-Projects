//
//  DoloExcerciseTests.swift
//  DoloExcerciseTests
//
//  Created by Alex Hoff on 3/20/18.
//  Copyright © 2018 Alex Hoff. All rights reserved.
//

import XCTest
@testable import DoloExcercise

fileprivate var request: AnyObject?

class DoloExcerciseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocationUrlBuilt() {
        // Given
        let targetUrl = URL(string: "https://api.foursquare.com/v2/venues/search?ll=37.802306,-122.4137&client_id=WTWVJKQOQATHLELVH31WZ2Q2V34M5TEQE1NE0EHYEZ31E443&client_secret=TAGFSMMES2N2D0GQQ4XO4O1ODDBN02QEIMBKBDRVVB3PZ1YA&intent=checkin&radius=500&limit=20&v=20180420")
        
        // When
        let lat = 37.802306
        let long = -122.4137
        let testUrl = URL.buildLocationUrl(lat: lat, long: long)
        
        // Then
        XCTAssertEqual(testUrl, targetUrl)
    }
    
    func testIconUrlStringBuilt() {
        // Given
        let targetUrl = "https://ss3.4sqi.net/img/categories_v2/shops/food_liquor_64.png"
        
        // When
        let prefix = "https://ss3.4sqi.net/img/categories_v2/shops/food_liquor_"
        let suffix = ".png"
        let icon = Icon(prefix: prefix, suffix: suffix)
        let testUrl = String.buildImageUrlString(icon: icon)
        
        //Then
        XCTAssertEqual(testUrl, targetUrl)
    }
    
    func testAPICallCompletes() {
        // Given
        let testUrl = URL(string: "https://api.foursquare.com/v2/venues/search?ll=37.802306,-122.4137&client_id=WTWVJKQOQATHLELVH31WZ2Q2V34M5TEQE1NE0EHYEZ31E443&client_secret=TAGFSMMES2N2D0GQQ4XO4O1ODDBN02QEIMBKBDRVVB3PZ1YA&intent=checkin&radius=500&limit=20&v=20180420")
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: String?
        
        // When
        let locationRequest = ApiRequest(url: testUrl!)
        request = locationRequest
        locationRequest.load { (session: Session?) in
            statusCode = session?.meta?.code
            responseError = session?.meta?.errorType
            
            // Make sure venues are not nil
            XCTAssertNotNil(session?.response?.venues)
            
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        
        // Then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
}
