import XCTest

import InjectedTests

var tests = [XCTestCaseEntry]()
tests += InjectedTests.allTests()
XCTMain(tests)
