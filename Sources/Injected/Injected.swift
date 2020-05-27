//
//  Injected.swift
//  Injected
//
//  Created by Grigory Avdyushin on 14/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

public struct Dependency {

    public typealias ResolveBlock<T> = () -> T

    fileprivate(set) var value: Any!
    fileprivate let block: ResolveBlock<Any>
    fileprivate let name: String

    public init<T>(_ block: @escaping ResolveBlock<T>) {
        self.block = block
        self.name = String(describing: T.self)
    }

    mutating func resolve() {
        value = block()
    }
}

@dynamicMemberLookup
open class Dependencies: Sequence {

    static private(set) var shared = Dependencies()

    fileprivate var dependencies = [Dependency]()

    @_functionBuilder public struct DependencyBuilder {
        public static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
        public static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    public init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
        dependencies().forEach { register($0) }
    }

    public init(@DependencyBuilder _ dependency: () -> Dependency) {
        register(dependency())
    }

    /// Builds (resolves) all dependencies graph
    open func build() {
        // We assuming that at this point all needed dependencies are registered
        for index in dependencies.startIndex..<dependencies.endIndex {
            dependencies[index].resolve()
        }
        Self.shared = self
    }

    /// Returns iterator for all registered dependencies
    public func makeIterator() -> AnyIterator<Any> {
        var iter = dependencies.makeIterator()
        return AnyIterator { iter.next()?.value }
    }

    /// Return dependency by given camelCase name of the object type
    /// For example: if dependency registered as `MyService` name should be `myService`
    public subscript<T>(dynamicMember name: String) -> T? {
        dependencies.first { $0.name == name.prefix(1).capitalized + name.dropFirst() }?.value as? T
    }

    // MARK: - Private

    fileprivate init() { }

    fileprivate func register(_ dependency: Dependency) {
        // Avoid duplicates
        guard dependencies.firstIndex(where: { $0.name == dependency.name }) == nil else {
            debugPrint("\(String(describing: dependency.name)) already registered, ignoring")
            return
        }
        dependencies.append(dependency)
    }

    fileprivate func resolve<T>() -> T {
        guard let dependency = dependencies.first(where: { $0.value is T })?.value as? T else {
            fatalError("Can't resolve \(T.self)")
        }
        return dependency
    }
}

@propertyWrapper
public class Injected<Dependency> {

    private var dependency: Dependency!

    public var wrappedValue: Dependency {
        if dependency == nil {
            let copy: Dependency = Dependencies.shared.resolve()
            self.dependency = copy
        }
        return dependency
    }

    public init() { }
}
