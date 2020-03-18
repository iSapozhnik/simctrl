import Foundation
import CombineX
import CXFoundation

public enum Simctrl {
//    private let executor = CommandExecutor()

//    var commandArguments: [StatusBarArgument]?
    
//    public init() {
//        Simctrl.execute(["openurl", "booted", "sixt://sixt.com/share"], completion: { result in
//            print(result)
//        })
//    }

    public static func openURL(_ simulator: String, URL: String) {
        CommandExecutor.execute(.openURL(deviceId: simulator, url: URL))
    }

    public static func watchDeviceList() -> AnyPublisher<DeviceList, SimctrlError> {
        return Timer.CX.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .setFailureType(to: SimctrlError.self)
            .flatMap { _ in Simctrl.listDevices() }
            .prepend(Simctrl.listDevices())
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public static func listDeviceTypes() -> AnyPublisher<DeviceTypeList, SimctrlError> {
        CommandExecutor.executeJSON(.list(filter: .devicetypes, flags: [.json]))
    }

    public static func listDevices() -> AnyPublisher<DeviceList, SimctrlError> {
        CommandExecutor.executeJSON(.list(filter: .devices, search: .available, flags: [.json]))
    }

    public static func listRuntimes() -> AnyPublisher<RuntimeList, SimctrlError> {
        CommandExecutor.executeJSON(.list(filter: .runtimes, flags: [.json]))
    }

//    public func changeBatteryLevel(_ value: Int) throws -> Simctrl {
//        createCommandArgumentsIfNeeded()
//        commandArguments?.appendUnique(.batteryLevel(value))
//        return self
//    }
//
//    public func updateWifiBars(_ value: Int) throws -> Simctrl {
//        createCommandArgumentsIfNeeded()
//        commandArguments?.appendUnique(.wifiBars(value))
//        return self
//    }
//
//    public func changeBatteryState(_ value: BatteryState) throws -> Simctrl {
//        createCommandArgumentsIfNeeded()
//        commandArguments?.appendUnique(.batteryState(value))
//        return self
//    }
//
//    public func deviceList() throws -> DeviceListResult? {
//        createCommandArgumentsIfNeeded()
//        let subCommand = DeviceListSubCommand()
//        let tool = SimCtlTool(subCommand: subCommand)
//        let xcrunCommand = XCRunCommand(tool: tool)
//
//        let decoder = DeviceListDecoder<DeviceListResult>()
//        return decoder.decode(string: executor.execute(xcrunCommand))
//    }
//
//    public func boot(device: DeviceElement) throws {
//        createCommandArgumentsIfNeeded()
//        let subCommand = BootDeviceSubCommand(device: Device.id(device.udid), arguments: nil)
//        let tool = SimCtlTool(subCommand: subCommand)
//        let xcrunCommand = XCRunCommand(tool: tool)
//        executor.execute(xcrunCommand)
//        executor.execute(OpenCommand())
//    }
//
//    public func open(device: DeviceElement?, url: String) throws {
//        createCommandArgumentsIfNeeded()
//        let bootedDevice = device != nil ? Device.id(device!.udid) : Device.booted
//        let subCommand = OpenURLSubCommand(device: bootedDevice, arguments: nil, url: url)
//        let tool = SimCtlTool(subCommand: subCommand)
//        let xcrunCommand = XCRunCommand(tool: tool)
//        executor.execute(xcrunCommand)
//    }
//
//    public func execute(for dvice: Device = .booted) throws {
//        guard let arguments = commandArguments else { return }
//
//        let subCommand = StatusBarSubCommand(action: .override, device: dvice, arguments: arguments)
//        let tool = SimCtlTool(subCommand: subCommand)
//        let xcrunCommand = XCRunCommand(tool: tool)
//
//        executor.execute(xcrunCommand)
//    }
//
//    private func createCommandArgumentsIfNeeded() {
//        if commandArguments == nil {
//            commandArguments = [StatusBarArgument]()
//        }
//    }
}

extension Simctrl {

    /// Open a URL in a device.
//    static func openURL(deviceId: String, url: String) -> Command {
//        Command("openurl", arguments: [deviceId, url])
//    }
}
