import XCTest
@testable import swift_pb

final class swift_pbTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_pb().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
