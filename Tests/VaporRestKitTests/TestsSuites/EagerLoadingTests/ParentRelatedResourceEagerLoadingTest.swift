//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class ParentRelatedResourceEagerLoadingTest: BaseVaporRestKitTest {
    func testEagerLoaderWithDynamicKeys() throws {
        try routes()
        try seed()

        try app.test(.GET, "v1/stars/1/belongs/ext_galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.ExtendedOutput<Star.Output>.self, res) {

                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")

                XCTAssertNil($0.stars)
            }
        }.test(.GET, "v1/stars/1/belongs/ext_galaxies/1?include=stars") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.ExtendedOutput<Star.Output>.self, res) {

                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")

                XCTAssertNotNil($0.stars)
                XCTAssertEqual($0.stars?.first?.id, 1)
                XCTAssertEqual($0.stars?.first?.title, "AnyStar")
            }
        }
    }

}
