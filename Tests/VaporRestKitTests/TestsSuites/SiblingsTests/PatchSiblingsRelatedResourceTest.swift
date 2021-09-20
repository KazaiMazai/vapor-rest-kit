//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 22.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class PatchSiblingsResourceTests: BaseVaporRestKitTest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PUT, "v1/stars/1/related/star_tags/1", body: StarTag.Input(title: "Very Small")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Very Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Very Small")
            }
        }
    }

    func testPatchWithEmptyData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PUT, "v1/stars/1/related/star_tags/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }
    }

    func testPatchWithInvalidData() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PATCH, "v1/stars/1/related/star_tags/1", body: StarTag.PatchInput(title: nil)) { res in
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
        }
    }
}

final class PatchSiblingsResourceDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PUT, "v1/stars/1/related/star_tags/1", body: StarTag.Input(title: "Very Small")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Very Small")
            }
        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Very Small")
            }
        }
    }

    func testPatchWithEmptyData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PUT, "v1/stars/1/related/star_tags/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/related/star_tags/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(StarTag.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Small")
            }
        }
    }

    func testPatchWithInvalidData() throws {
        try routes()

        try app.test(.GET, "v1/star_tags/1") { res in
            XCTAssertEqual(res.status, .notFound)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
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
        }.test(.POST, "v1/stars/1/related/star_tags", body: StarTag.Input(title: "Small")) { res in
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
        }.test(.PATCH, "v1/stars/1/related/star_tags/1", body: StarTag.PatchInput(title: nil)) { res in
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
        }
    }
}
