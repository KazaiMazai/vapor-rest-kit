//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 21.05.2020.
//


@testable import VaporRestKit
import XCTVapor


final class PatchChildTests: BaseVaporRestKitTest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Star.PatchInput(title: nil, subtitle: "A")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
                XCTAssertEqual($0.subtitle, "A")
            }
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
                XCTAssertEqual($0.subtitle, "A")
            }
        }
    }

    func testPatchWithEmptyData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .ok)
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }
    }

    func testPatchWithInvalidData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Galaxy.PatchInput(title: "M")) { res in
            XCTAssertEqual(res.status, .badRequest)
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }
    }
}


final class PatchChildDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testPatchWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Star.PatchInput(title: nil, subtitle: "A")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
                XCTAssertEqual($0.subtitle, "A")
            }
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
                XCTAssertEqual($0.subtitle, "A")
            }
        }
    }

    func testPatchWithEmptyData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .ok)
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }
    }

    func testPatchWithInvalidData() throws {
        struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/galaxies/1/contains/stars", body: Star.Input(title: "Sun")) { res in
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
        }.test(.PATCH, "v1/galaxies/1/contains/stars/1", body: Galaxy.PatchInput(title: "M")) { res in
            XCTAssertEqual(res.status, .badRequest)
        }.test(.GET, "v1/galaxies/1/contains/stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Sun")
            }
        }
    }

}
