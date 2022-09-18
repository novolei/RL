//
//  Defaults.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/16.
//

import Foundation
import SwiftUI
import Appwrite

class Defaults: ObservableObject {


    @AppStorage("_privateKey")  var privateKeyholder: String?
    @AppStorage("user")  var userHolder: Data?
    @AppStorage(Constant.SESSION_KEY)  var session: Data?
    public static let shared = Defaults()
}

@propertyWrapper
public struct Default<T>: DynamicProperty {
    @ObservedObject private var defaults: Defaults
    private let keyPath: ReferenceWritableKeyPath<Defaults, T>
     init(_ keyPath: ReferenceWritableKeyPath<Defaults, T>, defaults: Defaults = .shared) {
        self.keyPath = keyPath
        self.defaults = defaults
    }

    public var wrappedValue: T {
        get { defaults[keyPath: keyPath] }
        nonmutating set { defaults[keyPath: keyPath] = newValue }
    }

    public var projectedValue: Binding<T> {
        Binding(
            get: { defaults[keyPath: keyPath] },
            set: { value in
                defaults[keyPath: keyPath] = value
            }
        )
    }
}
