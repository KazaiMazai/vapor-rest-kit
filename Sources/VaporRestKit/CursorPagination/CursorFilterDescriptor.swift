//
//  
//  
//
//  Created by Sergey Kazakov on 09.05.2020.
//

import Vapor
import Fluent

extension QueryBuilder {
    func reverseSorts() {
        query.sorts = query.sorts.map { sort in sort.reversed() }
    }

    func getCursorFilterDescriptor() throws -> CursorFilterDescriptor {
        try CursorFilterDescriptor(sorts: query.sorts)
    }

    @discardableResult
    func filter(with cursorValues: [CursorValue]) throws -> QueryBuilder<Model> {
        let filterDescriptor = try getCursorFilterDescriptor()
        let cursorFilter = try CursorFilter(cursorValues: cursorValues,
                                            filterDescriptor: filterDescriptor)

        return filter(with: cursorFilter)
    }
}

//MARK:- CursorFilterDescriptor

struct CursorFilterDescriptor {
    let filterDescriptors: [FilterDescriptor]

    init(filterDescriptors: [FilterDescriptor]) {
        self.filterDescriptors = filterDescriptors
    }

    init(sorts: [DatabaseQuery.Sort]) throws {
        self.filterDescriptors = try sorts.map { try FilterDescriptor(sort: $0) }
    }
}

//MARK:- CursorFilter

fileprivate struct CursorFilter {
    let filters: [CursorValueFilter]

    init(filters: [CursorValueFilter]) {
        self.filters = filters
    }

    init(cursorValues: [CursorValue],
         filterDescriptor: CursorFilterDescriptor) throws {

        let filterDescriptors = filterDescriptor.filterDescriptors
        guard cursorValues.count == filterDescriptors.count else {
            throw Abort(.unprocessableEntity, reason: "Could not build cursor filter with provided values and filter descriptor")
        }

        filters = try zip(cursorValues, filterDescriptors).map { cursorValue, filter in
            try cursorValue.validateKey(with: filter.field)
            return CursorValueFilter(field: filter.field,
                                     method: filter.method,
                                     value: try cursorValue.value.toDatabaseQueryValue())
        }
    }
}

//MARK:- CursorValueFilter

fileprivate struct CursorValueFilter {
    let field: DatabaseQuery.Field
    let method: DatabaseQuery.Filter.Method
    let value: DatabaseQuery.Value
}

fileprivate extension QueryBuilder {

    @discardableResult
    func filter(with cursorFilter: CursorFilter) -> QueryBuilder<Model> {
        var filters = cursorFilter.filters
        let currentFilter = filters.removeFirst()
        let remainingFilters = CursorFilter(filters: filters)

        guard !remainingFilters.filters.isEmpty else {
            return filter(currentFilter.field, currentFilter.method, currentFilter.value)
        }

        guard case .null = currentFilter.value else {

            guard case .order(let inverse, _) = currentFilter.method, inverse == true else {
                return group(.or) { orGroup in
                    orGroup
                        .filter(currentFilter.field, currentFilter.method, currentFilter.value)
                        .group(.and) { andGroup in
                            andGroup
                                .filter(currentFilter.field, .equal, currentFilter.value)
                                .filter(with: remainingFilters)
                        }
                }
            }

            return group(.or) { orGroup in
                orGroup
                    .filter(currentFilter.field, currentFilter.method, currentFilter.value)
                    .filter(currentFilter.field, .equal, .null)
                    .group(.and) { andGroup in
                        andGroup
                            .filter(currentFilter.field, .equal, currentFilter.value)
                            .filter(with: remainingFilters)
                    }
            }
        }

        /**
         Cursor Value is nil

         if  '>' or '>=' filter for sorting direction and cursor value is nil, we we should check x != nil OR (x == nil AND remaining_filters)
         */
        guard case .order(let inverse, _) = currentFilter.method, inverse == true else {
            return group(.or) { orGroup in
                orGroup
                    .filter(currentFilter.field, .notEqual, .null)
                    .group(.and) { andGroup in
                        andGroup
                            .filter(currentFilter.field, .equal, .null)
                            .filter(with: remainingFilters)
                    }
            }
        }

        /**
         Cursor Value is nil

         if 'less' or  'lessOrEqual' filter for sorting direction appied and cursor value is nil, then we should check equal to nil in cursor filter
         */
        return group(.and) { andGroup in
            andGroup
                .filter(currentFilter.field, .equal, .null)
                .filter(with: remainingFilters)
        }
    }
}
