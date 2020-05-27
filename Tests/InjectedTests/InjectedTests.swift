import XCTest
@testable import Injected

final class InjectedTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Injected().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
