//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 22.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class SiblingsRelationsTests: BaseVaporRestKitTest {
    func testCreateAndDeleteRelation() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/star_tags", body: StarTag.Input(title: "Small")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
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
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/star_tags/1/related/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.POST, "v1/stars/1/related/star_tags/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/star_tags/1/related/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }

        }.test(.DELETE, "v1/stars/1/related/star_tags/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }
    }
}


final class SiblingsRelationsDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testCreateAndDeleteRelation() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.POST, "v1/star_tags", body: StarTag.Input(title: "Small")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
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
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }.test(.GET, "v1/star_tags/1/related/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.POST, "v1/stars/1/related/star_tags/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/star_tags/1/related/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }

        }.test(.DELETE, "v1/stars/1/related/star_tags/1/relation") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)

        }
    }
}
