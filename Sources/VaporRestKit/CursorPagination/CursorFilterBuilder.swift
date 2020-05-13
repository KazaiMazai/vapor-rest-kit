//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 09.05.2020.
//

import Vapor
import Fluent

//MARK:- CursorFilterBuilder

struct CursorFilterBuilder {
    let filterDescriptors: [FilterDescriptor]

    init(filterDescriptors: [FilterDescriptor]) {
        self.filterDescriptors = filterDescriptors
    }

    init(sorts: [DatabaseQuery.Sort]) throws {
        self.filterDescriptors = try sorts.map { try FilterDescriptor(sort: $0) }
    }

    func filter<Model>(_ queryBuilder: QueryBuilder<Model>, with values: [CursorValue]) throws -> QueryBuilder<Model> {
        let valueFilters = try prepareValueFilters(cursorValues: values, filterDescriptors: filterDescriptors)
        return applyCursorValueFilters(to: queryBuilder, valueFilters: valueFilters)
    }
}

//MARK:- CursorValueFilter

fileprivate struct CursorValueFilter {
    let field: DatabaseQuery.Field
    let method: DatabaseQuery.Filter.Method
    let value: DatabaseQuery.Value
}

//MARK:- CursorFilterBuilder Extension

extension CursorFilterBuilder {
    fileprivate func prepareValueFilters(cursorValues: [CursorValue],
                                         filterDescriptors: [FilterDescriptor]) throws -> [CursorValueFilter] {

        guard cursorValues.count == filterDescriptors.count else {
            throw Abort(.badRequest, reason: "Wrong cursor query parameter")
        }

        return try zip(cursorValues, filterDescriptors).map { cursorValue, filter in
            try cursorValue.validateKey(with: filter.field)
            return CursorValueFilter(field: filter.field,
                               method: filter.method,
                               value: try cursorValue.value.toDatabaseQueryValue())
        }
    }

    fileprivate func applyCursorValueFilters<Model>(to queryBuilder: QueryBuilder<Model>, valueFilters: [CursorValueFilter]) -> QueryBuilder<Model> {

        var filters = valueFilters
        let first = filters.removeFirst()

        guard !filters.isEmpty else {
            return queryBuilder.filter(first.field, first.method, first.value)
        }

        guard case .null = first.value else {

            guard case .order(let inverse, _) = first.method, inverse == true else {
                return queryBuilder.group(.or) { or in
                        _ = or.filter(first.field, first.method, first.value)
                              .group(.and) { and in
                                    _ = applyCursorValueFilters(to: and.filter(first.field, .equal, first.value),
                                                                valueFilters: filters)
                              }
                }
            }

            return queryBuilder.group(.or) { or in
                     _ = or.filter(first.field, first.method, first.value)
                           .filter(first.field, .equal, .null)
                           .group(.and) { and in
                                _ = applyCursorValueFilters(to: and.filter(first.field, .equal, first.value),
                                                            valueFilters: filters)
                            }
            }
        }

        /**
        Cursor Value is nil

        if  '>' or '>=' filter for sorting direction and cursor value is nil, we we should check x != nil OR (x == nil AND remaining_filters)
        */
        guard case .order(let inverse, _) = first.method, inverse == true else {
            return queryBuilder.group(.or) { or in
                    _ = or.filter(first.field, .notEqual, .null)
                          .group(.and) { and in
                                _ = applyCursorValueFilters(to: and.filter(first.field, .equal, .null),
                                                            valueFilters: filters)
                          }
            }
        }

        /**
        Cursor Value is nil

        if 'less' or  'lessOrEqual' filter for sorting direction appied and cursor value is nil, then we should check equal to nil in cursor filter
        */
        return queryBuilder.group(.and) { and in
            _ = applyCursorValueFilters(to: and.filter(first.field, .equal, .null),
                                        valueFilters: filters)
        }
    }
}
