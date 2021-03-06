//
//  UtilTest.swift
//  ZoeyApp
//
//  Created by Hien Tran on 1/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import XCTest
@testable import ZoeyApp

extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class UtilTest: XCTestCase {

    let util = Util()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMS() {
        
        let arr = [1.0, 2.0, 3.0, 4.0, 5.0]
        
        let result = 11.0
        
        XCTAssertEqual(util.testms(array: arr), result)
        
    }
    
    func testInitVect() {
        let result = [1.0, 1.0, 1.0, 1.0]
        
        XCTAssertEqual(util.initFeatVec(count: 4, val: 1.0) as! [Double], result)
    }
    
    func testAvgAxisValue() {
        let axisVals = [[1.0, 2.0, 3.0],[2.0, 3.0, 4.0],[3.0, 4.0, 5.0],[4.0, 5.0, 6.0]]
        
        let result = [2.5, 3.5, 4.5]
        
        XCTAssertEqual(util.avgAxisValue(data: axisVals), result)
    }
    
    func testRootMeanSquareAxisVals() {
        let axisVals = [[1.0, 2.0, 3.0],[2.0, 3.0, 4.0],[3.0, 4.0, 5.0],[4.0, 5.0, 6.0]]
        
        let result = [(sqrt(30)/2).roundTo(places: 4), (sqrt(54)/2).roundTo(places: 4), (sqrt(86)/2).roundTo(places: 4)]
        
        XCTAssertEqual(util.rootMeanSquareAxisVals(data: axisVals), result)
    }
    
}
