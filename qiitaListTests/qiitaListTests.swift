//
//  qiitaListTests.swift
//  qiitaListTests
//
//  Created by 山崎友弘 on 2015/04/11.
//  Copyright (c) 2015年 basic. All rights reserved.
//

import UIKit
import XCTest
import OHHTTPStubs

class qiitaListTests: XCTestCase {
    
    weak var textStub: OHHTTPStubsDescriptor?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        textStub = OHHTTPStubs.stubRequestsPassingTest({$0.URL!.pathExtension == "txt"}) { _ in
            let stubPath = OHPathForFile("stub.txt", self.dynamicType)
            return OHHTTPStubsResponse(
                fileAtPath: stubPath!,
                statusCode: 200,
                headers: ["Content-Type":"text/plain"]
                )
                .requestTime(2, responseTime:OHHTTPStubsDownloadSpeed3G)
        }
        
        textStub?.name = "Text stub"
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        OHHTTPStubs.removeStub(textStub!)
        
        super.tearDown()
    }
    
    func testExample() {
//        XCTestExpectation *documentOpenExpectation = [self expectationWithDescription:@"document open"];
        let documentOpenExpectation = self.expectationWithDescription("document open")
        
        
        // This is an example of a functional test case.
        let urlString = "http://www.opensource.apple.com/source/Git/Git-26/src/git-htmldocs/git-commit.txt?txt"
        let req = NSURLRequest(URL: NSURL(string: urlString)!)
        
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) { (_, data, _) in
            let receivedText = NSString(data: data, encoding: NSASCIIStringEncoding)
            println("スタート\n" + String(receivedText!) + "\nおわり")
            XCTAssert(true, "失敗")
            
            documentOpenExpectation.fulfill()
        }
        

        
        self.waitForExpectationsWithTimeout(1, handler: { (error) -> Void in
        })
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
