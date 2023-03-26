//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.03.2023.
//


@testable import VaporRestKit
import XCTVapor

final class BeforeCursorPaginationTests: BaseVaporRestKitTest {
  
    func testCursorPaginationWithValueFilter() throws {


        let limit = 2
        var nextCursor: String = ""
        var prevCursor: String = ""
        var lastItemIndex: Int = 0

        let stars = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .all()
            .wait()
            .map { Star.Output($0) }



        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)") { res in
            XCTAssertEqual(res.status, .ok)

            XCTAssertContent(CursorPage<Star.Output>.self, res) {
                nextCursor = $0.metadata.nextCursor ?? ""
                lastItemIndex += limit
            }
        }

        var hasMore = true
        while hasMore {
            appTester = try appTester.test(.GET, "v1/stars?after=\(nextCursor)&limit=\(limit)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    nextCursor = $0.metadata.nextCursor ?? nextCursor
                    prevCursor = $0.metadata.prevCursor ?? prevCursor

                    hasMore =  $0.metadata.nextCursor != nil
                }
            }
        }

        var pages: [[Star.Output]] = []

        for endIndex in stride(from: stars.count - 1, through: 0, by: -limit) {
            let startIndex = max(0, endIndex - limit)
            pages.append(Array(stars[startIndex..<endIndex]))
        }

        for page in pages {
            appTester = try appTester.test(.GET, "v1/stars?before=\(prevCursor)&limit=\(limit)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) { content in
                    prevCursor = content.metadata.prevCursor ?? prevCursor

                    XCTAssertEqual(page, content.items)
                }
            }
        }
    }
}

/*
    func testCursorPaginationWithUnsupportedFilter() throws {
        
        

        let limit = 1

        let filterDict: [String: [String: String]] = ["value": ["value": "1",
                                                                "method": "eq",
                                                                "key": "id"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
            XCTAssertEqual(res.status, .badRequest)
        }
    }

    func testCursorPaginationWithContainsValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] =  ["value": ["value": "b",
                                                                 "method": "like",
                                                                 "key": "title"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$title, .contains(inverse: false, .anywhere), "b")
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithNotEqualValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] =
            [ "value": [ "value": "Sun",
                         "method": "ne",
                         "key": "title"]
            ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$title, .notEqual, "Sun")
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithEqualNumericValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = [ "value": [ "value": "60",
                                                                  "method": "eq",
                                                                  "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .equal, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithNotEqualNumericValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["value":  ["value": "60",
                                                                 "method": "ne",
                                                                 "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .notEqual, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
                XCTAssertEqual(res.status, .ok)

                XCTAssertContent(CursorPage<Star.Output>.self, res) {
                    cursor = $0.metadata.nextCursor ?? ""

                    XCTAssertLessThanOrEqual($0.items.count, limit)
                    let endIndex = min(itemIndex + limit, titles.count)
                    let expectedTitles = titles[itemIndex..<endIndex]
                    print("\($0.items) || \(expectedTitles)")
                    zip($0.items, expectedTitles).forEach {
                        XCTAssertEqual($0.0.title, $0.1)
                    }
                }
            }
        }
    }

    func testCursorPaginationWithGreaterThenOrEqualValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["value": ["value": "60",
                                                                "method": "gte",
                                                                "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .greaterThanOrEqual, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithGreaterThenValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["value": ["value": "60",
                                                                "method": "gt",
                                                                "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .greaterThan, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithLessThenValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["value": ["value": "60",
                                                                "method": "lt",
                                                                "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .lessThan, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithLessThenOrEqualValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["value": ["value": "60",
                                                                "method": "lte",
                                                                "key": "size"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$size, .lessThanOrEqual, 60)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithFieldFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["field": ["lhs": "title",
                                                                "method": "eq",
                                                                "rhs": "subtitle"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$title, .equal, \Star.$subtitle)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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

    func testCursorPaginationWithNotEqualFieldFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict: [String: [String: String]] = ["field": ["lhs": "title",
                                                                "method": "ne",
                                                                "rhs": "subtitle"]
        ]

        let filterJSONData = try JSONEncoder().encode(filterDict)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .filter(\Star.$title, .notEqual, \Star.$subtitle)
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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


    func testCursorPaginationWithValueDisjFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict1: [String: [String: String]] = ["value": ["value": "Sun",
                                                                 "method": "eq",
                                                                 "key": "title"]
        ]

        let filterDict2: [String: [String: String]] = ["value": ["value": "a",
                                                                 "method": "like",
                                                                 "key": "title"]
        ]

        let compoundFilter = ["or": [filterDict1, filterDict2] ]

        let filterJSONData = try JSONEncoder().encode(compoundFilter)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .group(.or) { (qb) in
                qb.filter(\Star.$title, .equal, "Sun")
                    .filter(\Star.$title, .contains(inverse: false, .anywhere), "a")
            }
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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


    func testCursorPaginationWithConjValueFilter() throws {
        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict1: [String: [String: String]] = ["value": ["value": "AnyStar",
                                                                 "method": "ne",
                                                                 "key": "title"]
        ]

        let filterDict2: [String: [String: String]] = ["value": ["value": "a",
                                                                 "method": "like",
                                                                 "key": "title"]
        ]

        let compoundFilter = ["and": [filterDict1, filterDict2] ]

        let filterJSONData = try JSONEncoder().encode(compoundFilter)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .group(.and) { (qb) in
                qb.filter(\Star.$title, .notEqual, "AnyStar")
                    .filter(\Star.$title, .contains(inverse: false, .anywhere), "a")
            }
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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


    func testCursorPaginationWithConjAndDisjNestedFilter() throws {

        
        

        let limit = 1
        var cursor: String = ""
        var lastItemIndex: Int = 0

        let filterDict1: [String: [String: String]] = ["field": ["lhs": "title",
                                                                 "method": "eq",
                                                                 "rhs": "subtitle"]
        ]


        let filterDict2: [String: [String: String]] = ["value": ["value": "a",
                                                                 "method": "like",
                                                                 "key": "title"]
        ]

        let filterDict3: [String: [String: String]] = ["value": ["value": "c",
                                                                 "method": "like",
                                                                 "key": "title"]
        ]

        let compoundFilter: [String: AnyEncodable] = [
            "or": [filterDict3, ["and": [filterDict1, filterDict2]]]
        ]

        let filterJSONData = try JSONEncoder().encode(compoundFilter)
        let filterString = String(bytes: filterJSONData, encoding: .utf8) ?? ""

        let titles = try Star.query(on: app.db)
            .sort(\Star.$id, .ascending)
            .group(.or) { or in
                or.filter(\Star.$title, .contains(inverse: false, .anywhere), "c")
                    .group(.and) { and in
                        and.filter(\Star.$title, .equal, \Star.$subtitle)
                            .filter(\Star.$title, .contains(inverse: false, .anywhere), "a")
                    }
            }
            .all()
            .wait()
            .map { $0.title }

        var appTester = try app.test(.GET, "v1/stars?limit=\(limit)&filter=\(filterString)") { res in
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
            appTester = try appTester.test(.GET, "v1/stars?\(cursorParameterName)=\(cursor)&limit=\(limit)&filter=\(filterString)") { res in
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
}
*/
