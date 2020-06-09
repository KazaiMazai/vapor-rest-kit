//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.06.2020.
//

@testable import VaporRestKit
import XCTVapor

final class ParentChildPaginationWithSortTests: BaseVaporRestKitTest {
    func testCursorPaginationWithDefaultIdSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertLessThanOrEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.title, $0.1)
                }


                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.title, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithFieldAscSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""

        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .ascending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:asc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertLessThanOrEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.title, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:asc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.title, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithFieldDescSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""

        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.title, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:desc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.title, $0.1)
                    }
                }
            }
        }
    }


    func testCursorPaginationWithOptionalFieldAscSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""

        var lastItemIndex: Int = 0
        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .ascending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:asc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:asc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithOptionalFieldDescSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:desc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiDescDescSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .descending)
            .sort(\Star.$subtitle, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:desc,subtitle:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:desc,subtitle:desc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiDescAscSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .descending)
            .sort(\Star.$subtitle, .ascending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:desc,subtitle:asc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:desc,subtitle:asc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiAscAscSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .ascending)
            .sort(\Star.$subtitle, .ascending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:asc,subtitle:asc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:asc,subtitle:asc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiAscDescSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$title, .ascending)
            .sort(\Star.$subtitle, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=title:asc,subtitle:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=title:asc,subtitle:desc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiDescDescRevSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .descending)
            .sort(\Star.$title, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:desc,title:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:desc,title:desc,") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiDescAscRevSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .ascending)
            .sort(\Star.$title, .descending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:asc,title:desc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:asc,title:desc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiAscAscRevSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .ascending)
            .sort(\Star.$title, .ascending)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:asc,title:asc") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:asc,title:asc") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithMultiAscDescRevSort() throws {
        try routes()
        try seed()

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let galaxy = try Galaxy.query(on: app.db)
            .filter(\Galaxy.$id, .equal, 1)
            .first()
            .wait()!

        let titles = try galaxy.$stars
            .query(on: app.db)
            .sort(\Star.$subtitle, .descending)
            .sort(\Star.$title, .ascending)

            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { $0.subtitle }

        var appTester = try app.test(.GET, "v1/galaxies/1/contains/stars?limit=\(limit)&sort=subtitle:desc,title:asc") { res in
            XCTAssertEqual(res.status, .ok)
            XCTAssertNotEqual(res.status, .notFound)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                cursor = $0.metadata.nextCursor ?? ""
                XCTAssertGreaterThan(cursor.count, 0)
                XCTAssertEqual($0.items.count, limit)

                let endIndex = min(lastItemIndex + limit, titles.count)
                let expectedTitles = titles[lastItemIndex..<endIndex]
                zip($0.items, expectedTitles).forEach {
                    XCTAssertEqual($0.0.subtitle, $0.1)
                }

                lastItemIndex += limit
            }
        }

        for itemIndex in stride(from: lastItemIndex, through: titles.count, by: limit) {
            appTester = try appTester.test(.GET, "v1/galaxies/1/contains/stars?cursor=\(cursor)&limit=\(limit)&sort=subtitle:desc,title:asc") { res in
                XCTAssertEqual(res.status, .ok)
                XCTAssertNotEqual(res.status, .notFound)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]

                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.subtitle, $0.1)
                    }
                }
            }
        }
    }

}
