//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 23.05.2020.
//

@testable import VaporRestKit
import XCTVapor

final class ChildRelatedResourceEagerLoadingTest: BaseVaporRestKitTest {
    func testEagerLoaderWithStaticAndDynamicKeys() throws {
        try routes()
        try seed()

        try app.test(.GET, "v1/galaxies/1/contains/ext_stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNil($0.tags)
            }
        }.test(.GET, "v1/galaxies/1/contains/ext_stars/1?include=non_existing_key") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNil($0.tags)

            }
        }.test(.GET, "v1/galaxies/1/contains/ext_stars/1?include=galaxy") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNil($0.tags)
            }
        }.test(.GET, "v1/galaxies/1/contains/ext_stars/1?include=galaxy,tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")
                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)
                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }.test(.GET, "v1/galaxies/1/contains/ext_stars/1?include=tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNil($0.galaxy)

                XCTAssertNotNil($0.tags)
                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }
    }

    func testEagerLoaderWithStaticKeys() throws {
        try routes()
        try seed()

        try app.test(.GET, "v1/galaxies/1/contains/full_stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)
                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")

            }
        }.test(.GET, "v1/galaxies/1/contains/full_stars/1?include=non_existing_key") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)
                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")

            }
        }.test(.GET, "v1/galaxies/1/contains/full_stars/1?include=galaxy") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)

                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }.test(.GET, "v1/galaxies/1/contains/full_stars/1?include=galaxy,tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")
                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)

                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }.test(.GET, "v1/galaxies/1/contains/full_stars/1?include=tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)

                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }
    }

    func testEagerLoaderWithDynamicKeys() throws {
        try routes()
        try seed()

        try app.test(.GET, "v1/galaxies/1/contains/d_stars/1") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNil($0.galaxy)
                XCTAssertNil($0.tags)

            }
        }.test(.GET, "v1/galaxies/1/contains/d_stars/1?include=non_existing_key") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNil($0.galaxy)
                XCTAssertNil($0.tags)

            }
        }.test(.GET, "v1/galaxies/1/contains/d_stars/1?include=galaxy") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNil($0.tags)

            }
        }.test(.GET, "v1/galaxies/1/contains/d_stars/1?include=galaxy,tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNotNil($0.galaxy)
                XCTAssertEqual($0.galaxy?.id, 1)
                XCTAssertEqual($0.galaxy?.title, "Milky Way")

                XCTAssertNotNil($0.tags)

                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }.test(.GET, "v1/galaxies/1/contains/d_stars/1?include=tags") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(Star.ExtendedOutput<Galaxy.Output, StarTag.Output>.self, res) {
                XCTAssertNotNil($0.id)
                XCTAssertEqual($0.id, 1)
                XCTAssertEqual($0.title, "AnyStar")

                XCTAssertNil($0.galaxy)

                XCTAssertNotNil($0.tags)

                XCTAssertEqual($0.tags?.first?.id, 1)
                XCTAssertEqual($0.tags?.first?.title, "Small")
            }
        }
    }
}
