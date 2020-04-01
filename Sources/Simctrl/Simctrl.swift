import Foundation
import CombineX
import CXFoundation

public enum Simctrl {
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
}
