import XCTest
@testable import swift_pb

final class swift_pbTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        var pb = ProgressBar(total: 100_000)
        //pb.tickFormat("▀▐▄▌")
        //pb.tickFormat("\\|/-")
        pb.showTick = true
        pb.format("╢▌▌░╟")
        pb.showTimeLeft = true
        pb.showPercent = true
        pb.showSpeed = false
        pb.units = .Bytes
        for i in 0..<100_000 {
            
            let _ = pb.inc()
            
        }
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
