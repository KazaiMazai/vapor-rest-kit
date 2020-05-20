//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 20.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class CreateTests: BaseVaporRestKitStarsTest {
    func testCreateWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "v1/stars", body: Star.Input(title: "Sun")) { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }
    }

    func testCreateWithoutData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "v1/stars", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }

    func testCreateWithInvalidData() throws {
        try routes()

        try app.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.POST, "v1/stars", body: Star.Input(title: "S")) { res in
            XCTAssertEqual(res.status, .badRequest)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }
    }
}

