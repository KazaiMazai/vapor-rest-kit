//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 22.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class UpdateParentTests: BaseVaporRestKitTest {
    func testUpdateWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Galaxy.Input(title: "IC 1101")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "IC 1101")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "IC 1101")
            }
        }
    }


    func testUpdateWithEmptyData() throws {
         struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
        .test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
    }


    func testUpdateWithInvalidData() throws {
         struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
        .test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Galaxy.Input(title: "M")) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
    }
}

final class UpdateParentDeprecatedAPITests: BaseVaporRestKitDeprecatedAPITest {
    func testUpdateWithValidData() throws {
        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Galaxy.Input(title: "IC 1101")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "IC 1101")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "IC 1101")
            }
        }
    }


    func testUpdateWithEmptyData() throws {
         struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
        .test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Empty()) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
    }


    func testUpdateWithInvalidData() throws {
         struct Empty: Content {}

        try routes()

        try app.test(.GET, "v1/galaxies/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
        }.test(.GET, "v1/stars/1") { res in
            XCTAssertEqual(res.status, .notFound)
            XCTAssertNotEqual(res.status, .ok)
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
        }.test(.POST, "v1/stars/1/belongs/galaxies", body: Galaxy.Input(title: "Milky Way")) { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
        .test(.PUT, "v1/stars/1/belongs/galaxies/1", body: Galaxy.Input(title: "M")) { res in
            XCTAssertEqual(res.status, .badRequest)

        }.test(.GET, "v1/stars/1/belongs/galaxies/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Galaxy.Output.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "Milky Way")
            }
        }
    }
}
