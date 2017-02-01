//
//  UtilTest.swift
//  ZoeyApp
//
//  Created by Hien Tran on 1/2/17.
//  Copyright © 2017 Hien Tran. All rights reserved.
//

import XCTest
@testable import ZoeyApp

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
        let result = [2.0, 1.0, 1.0, 1.0]
        
        XCTAssertEqual(util.initFeatVec(count: 4, val: 1.0) as! [Double], result)
    }
    
}
