//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 21.05.2020.
//

import Foundation

@testable import VaporRestKit
import XCTVapor


final class ChildRelationsTests: BaseVaporRestKitStarsTest {
    func testCreateAndDeleteRelation() throws {
        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.POST, "v1/stars", body: Star.Input(title: "Sun")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/galaxies/1/contains/stars/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }

        }.test(.DELETE, "v1/galaxies/1/contains/stars/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }.test(.GET, "v1/galaxies/1/contains/stars/1/relation") { res in
            XCTAssertEqual(res.status, .notFound)

        }
    }
}
