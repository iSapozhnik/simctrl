import Foundation

public class Simctrl {
    private let executor = CommandExecutor()

    var commandArguments: [StatusBarArgument]?
    
    public init() {}

    public func changeBatteryLevel(_ value: Int) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.appendUnique(.batteryLevel(value))
        return self
    }

    public func updateWifiBars(_ value: Int) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.appendUnique(.wifiBars(value))
        return self
    }

    public func changeBatteryState(_ value: BatteryState) throws -> Simctrl {
        createCommandArgumentsIfNeeded()
        commandArguments?.appendUnique(.batteryState(value))
        return self
    }

    public func deviceList() throws -> DeviceListResult? {
        createCommandArgumentsIfNeeded()
        let subCommand = DeviceListSubCommand()
        let tool = SimCtlTool(subCommand: subCommand)
        let xcrunCommand = XCRunCommand(tool: tool)

        let decoder = DeviceListDecoder()
        return decoder.decode(string: executor.execute(xcrunCommand))
    }

    public func boot(device: DeviceElement) throws {
        createCommandArgumentsIfNeeded()
        let subCommand = BootDeviceSubCommand(device: Device.id(device.udid), arguments: nil)
        let tool = SimCtlTool(subCommand: subCommand)
        let xcrunCommand = XCRunCommand(tool: tool)
        executor.execute(xcrunCommand)
    }

    public func execute(for dvice: Device = .booted) throws {
        guard let arguments = commandArguments else { return }

        let subCommand = StatusBarSubCommand(action: .override, device: dvice, arguments: arguments)
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
