import XCTest
@testable import Simctrl

final class SimctrlTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Simctrl().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
