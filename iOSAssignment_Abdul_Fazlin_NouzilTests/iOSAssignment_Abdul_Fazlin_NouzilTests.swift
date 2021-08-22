//
//  iOSAssignment_Abdul_Fazlin_NouzilTests.swift
//  iOSAssignment_Abdul_Fazlin_NouzilTests
//
//  Created by Abdul Fazlin Nouzil on 8/18/21.
//

import XCTest
@testable import iOSAssignment_Abdul_Fazlin_Nouzil

class getItemsApiUnitTests: XCTestCase {
    
    
    
//    func test_GetItemsApi_WithValidUrl_ReturnsValidItemResponse(){
//        guard let url = URL(string:Constants.baseUrl) else { return }
//
//        let expectation = self.expectation(description: "ReturnsValidItemResponse")
//
//        HTTPUtility.shared.getData(requestUrl:url , resultType: Array<Item>.self) { (items) in
//
//            _ = items.map {[weak self] items in
//                DispatchQueue.main.async {
//                    XCTAssertNotNil(items)
//                    expectation.fulfill()
//                }
//            }
//        }
//        waitForExpectations(timeout: 10, handler:nil)
//    }
    
    // Black Box Tests for the API
    
    func test_GetItemsApi_WithInValidUrl_ReturnsError(){
        guard let url = URL(string:Constants.incorrectBaseUrl) else { return }
        
        let expectation = self.expectation(description: "ReturnsError")
        
        HTTPUtility.shared.getData(requestUrl:url , resultType: Array<Item>.self) { (items) in
            XCTAssertNotNil(items)
            expectation.fulfill()
            }
        waitForExpectations(timeout: 10, handler:nil)
    }

}

