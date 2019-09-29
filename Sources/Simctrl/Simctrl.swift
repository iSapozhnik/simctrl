import Foundation

public class Simctrl {
    private let executor = CommandExecutor()

    var commandArguments: [StatusBarArgument]?
    
    public init() {}

    public func changeBatteryLevel(_ value: Int) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.append(.batteryLevel(value))
        return self
    }

    public func changeWifiBars(_ value: Int) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.append(.wifiBars(value))
        return self
    }

    public func changeBatteryState(_ value: BatteryState) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.append(.batteryState(value))
        return self
    }

    public func deviceList() throws -> [String: [DeviceDescription]] {
        createCommandArgumentsIfNeeded()
        let subCommand = DeviceListSubCommand()
        let tool = SimCtlTool(subCommand: subCommand)
        let xcrunCommand = XCRunCommand(tool: tool)

        let parser = DeviceListParser()
        return parser.parse(string: executor.execute(xcrunCommand))
    }

    public func execute() throws {
        guard let arguments = commandArguments else { return }

        let subCommand = StatusBarSubCommand(action: .override, device: Device.booted, arguments: arguments)
        let tool = SimCtlTool(subCommand: subCommand)
        let xcrunCommand = XCRunCommand(tool: tool)

        executor.execute(xcrunCommand)
    }

    private func createCommandArgumentsIfNeeded() {
        if commandArguments == nil {
            commandArguments = [StatusBarArgument]()
        }
    }
}

//@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}
//
//func shell(_ command: String) -> String {
//    let task = Process()
//    task.launchPath = "/bin/bash"
//    task.arguments = ["-c", command]
//
//    let pipe = Pipe()
//    task.standardOutput = pipe
//    task.launch()
//
//    let data = pipe.fileHandleForReading.readDataToEndOfFile()
//    let output: String = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
//
//    return output
//}
//
//shell("xcrun simctl status_bar booted override --time \"9:41\" --batteryState charged --batteryLevel 10")
