import XCTest
@testable import Simctrl

final class SimctrlTests: XCTestCase {
    func testExample() {
        var arguments = [Argument]()
        arguments.append(.batteryLevel(50))
        let subCommand = StatusBarSubCommand(device: Device.booted, arguments: arguments)
        let tool = SimCtlTool(subCommand: subCommand)
        let xcrunCommand = XCRunCommand(tool: tool)

        XCTAssertEqual(xcrunCommand.stringRepresentation, "simctl booted --batteryLevel 50")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
