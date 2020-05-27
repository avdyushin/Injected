//
//  LinuxMain.swift
//  Injected
//
//  Created by Grigory Avdyushin on 14/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest

import InjectedTests

var tests = [XCTestCaseEntry]()
tests += InjectedTests.allTests()
XCTMain(tests)
