//
//  YClientTest.swift
//  YelpAssignment
//
//  Created by seema phalke on 2016-04-17.
//  Copyright © 2016 seema phalke. All rights reserved.
//

import Foundation
import XCTest

@testable import YelpAssignment


let yelpConsumerKey = "C6uWCSlZN-pt1qMSzQyeAQ"
let yelpConsumerSecret = "mCV_4NS3bvZjxCSNvA8e_1djmtE"
let yelpToken = "IFT9QzRtzVcfH0O6LR7TK5hwtDKKdZBc"
let yelpTokenSecret = "_7yceRZuAeaIDuJnHRo7gWfWRFc"

class YClientTest : XCTestCase{
    func testEthopianCategory(){
        let expectation = expectationWithDescription("ready")
        let yClient =  YelpClient(consumerKey: yelpConsumerKey, consumerSecret: yelpConsumerSecret, accessToken: yelpToken, accessSecret: yelpTokenSecret)
        
        let parameters = [
            "ll": "51.05,-114.08592",
            "category_filter": "ethiopian"
        ]
        
        yClient.searchWithTerm("Ethiopian", parameters: parameters, offset: 0, limit: 20, success: {
            (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
              XCTAssertNotNil(response)
              expectation.fulfill()
            }, failure: {
                (operation: AFHTTPRequestOperation?, error: NSError!) -> Void in
                 XCTAssertNil(error)
                 expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(3.0){ response in
        
            
        }
    }
}