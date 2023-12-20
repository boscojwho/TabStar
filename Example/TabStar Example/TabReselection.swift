//
//  TabReselection.swift
//  TabStar Example
//
//  Created by Bosco Ho on 2023-12-19.
//

import SwiftUI

extension Binding {
    func onUpdate(_ closure: @escaping (Value, Value) -> Void) -> Binding<Value> {
        Binding(get: {
            wrappedValue
        }, set: { newValue in
            let oldValue = wrappedValue
            wrappedValue = newValue
            closure(oldValue, newValue)
        })
    }
}
