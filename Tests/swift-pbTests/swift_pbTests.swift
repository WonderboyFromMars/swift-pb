import XCTest
@testable import swift_pb

final class swift_pbTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swift_pb().text, "Hello, World!")
        
        var pb = ProgressBar(total: 100_000)
        pb.tickFormat(Constants.TICK_FORMAT)
        pb.format("[=>_]")
        for _ in 0..<100_000 {
            pb.add(1)
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
