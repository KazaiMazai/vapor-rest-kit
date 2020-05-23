//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 20.05.2020.
//

import XCTVapor

extension XCTApplicationTester {
    typealias ResponseHandler = (XCTHTTPResponse) throws -> Void

    @discardableResult func test<Body>(_ method: HTTPMethod,
                                              _ path: String,
                                              body: Body,
                                              afterResponse: ResponseHandler = { _ in }) throws -> XCTApplicationTester
    where Body: Content {

            try test(method,
                     path,
                     beforeRequest: { req in try req.content.encode(body) },
                     afterResponse: afterResponse)
    }
}
