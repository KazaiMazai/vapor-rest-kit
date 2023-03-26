//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.03.2023.
//

@testable import VaporRestKit
import XCTVapor

final class AfterPaginationWithFilterTests: PaginationWithFilterTests {
    override var cursorParameterName: String { "after" }
}
