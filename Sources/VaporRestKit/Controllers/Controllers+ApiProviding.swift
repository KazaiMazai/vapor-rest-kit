//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 04.05.2020.
//

import Vapor
import Fluent

extension CreatableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = resourcePathFor(endpoint: endpoint)
        routeBuilder.on(.POST, path, body: .collect, use: self.create)
    }
}

extension CreatableRelationController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = resourcePathFor(endpoint: endpoint)
        routeBuilder.on(.POST, path, body: .collect, use: self.create)
    }
}

extension DeletableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = idResourcePathFor(endpoint: endpoint)
        routeBuilder.on(.DELETE, path, body: .collect, use: self.delete)
    }
}

extension DeletableRelationController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = idResourcePathFor(endpoint: endpoint)
        routeBuilder.on(.DELETE, path, body: .collect, use: self.delete)
    }
}

extension IterableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = resourcePathFor(endpoint: endpoint)
        switch config {
        case .fetchAll:
            routeBuilder.on(.GET, path, body: .collect, use: self.readAll)
        case .paginateWithCursor:
            routeBuilder.on(.GET, path, body: .collect, use: self.readWithCursorPagination)
        case .paginateByPage:
            routeBuilder.on(.GET, path, body: .collect, use: self.readWithPagination)
        }
    }
}

extension PatchableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = idResourcePathFor(endpoint: endpoint)
        routeBuilder.on(.PATCH, path, body: .collect, use: self.patch)
    }
}

extension ReadableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = idResourcePathFor(endpoint: endpoint)
        routeBuilder.on(.GET, path, body: .collect, use: self.read)
    }
}

extension UpdateableResourceController where Self: ResourceModelProvider {
    func addMethodsTo(_ routeBuilder: RoutesBuilder, on endpoint: String) {
        let path = idResourcePathFor(endpoint: endpoint)
        routeBuilder.on(.PUT, path, body: .collect, use: self.update)
    }
}
