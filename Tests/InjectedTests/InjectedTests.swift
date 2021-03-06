//
//  InjectedTests.swift
//  Injected
//
//  Created by Grigory Avdyushin on 14/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
@testable import Injected

protocol ServiceA { func run() -> Bool }
protocol ServiceB { func fetch() -> [String] }

struct ServiceAImpl: ServiceA {
    func run() -> Bool { true }
}

struct ServiceBImpl: ServiceB {
    func fetch() -> [String] { ["Foo"] }
}

final class InjectedTests: XCTestCase {

    let deps = Dependencies {
        Dependency { ServiceAImpl() }
        Dependency { ServiceBImpl() }
    }

    @Injected var serviceA: ServiceA
    @Injected var serviceB: ServiceB

    override func setUpWithError() throws {
        try super.setUpWithError()
        deps.build()
    }

    func testExample() {
        XCTAssertTrue(serviceA.run())
        XCTAssertEqual(serviceB.fetch().first, "Foo")
    }

    func testIterator() {
        for service in deps {
            XCTAssertTrue(service is ServiceA || service is ServiceB)
        }
    }

    func testMemberLookup() {
        let serviceA: ServiceA = deps.serviceAImpl!
        XCTAssertTrue(serviceA.run())
        let serviceB: ServiceB = deps.serviceBImpl!
        XCTAssertEqual(serviceB.fetch().first, "Foo")
    }

    func testShared() {
        let serviceA: ServiceA = Dependencies.shared.resolve()
        XCTAssertTrue(serviceA.run())
        let serviceB: ServiceB = Dependencies.shared.resolve()
        XCTAssertEqual(serviceB.fetch().first, "Foo")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
