//
//  File.swift
//  
//
//  Created by Sergey Kazakov on 26.03.2020.
//

import Fluent
import Vapor


//MARK:- FieldKeyRepresentable

protocol FieldKeyRepresentable: RawRepresentable {

}

extension FieldKeyRepresentable where RawValue == String  {
    var key: FieldKey {
        return FieldKey.string(rawValue.camelCaseToSnakeCase())
    }
}


