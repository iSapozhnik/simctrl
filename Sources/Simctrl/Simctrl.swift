import Foundation
import CombineX
import CXFoundation

public enum Simctrl {
    public static func acceptXcodeLicense(from url: URL) {
    
    }

    public static func recordVideo(from url: URL, simulator: String, urlString: String) -> Process? {
        CommandExecutor.executeProcess(from: url, command: .recordVideo(deviceId: simulator, url: urlString))
    }

    public static func openURL(from url: URL, simulator: String, urlString: String) {
        CommandExecutor.execute(from: url, command: .openURL(deviceId: simulator, url: urlString))
    }

    public static func boot(from url: URL, simulator: String) {
        CommandExecutor.execute(from: url, command: .boot(deviceId: simulator))
    }

    public static func watchDeviceList(from url: URL) -> AnyPublisher<DeviceList, SimctrlError> {
        return Timer.CX.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .setFailureType(to: SimctrlError.self)
            .flatMap { _ in Simctrl.listDevices(from: url) }
            .prepend(Simctrl.listDevices(from: url))
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public static func listDeviceTypes(from url: URL) -> AnyPublisher<DeviceTypeList, SimctrlError> {
        CommandExecutor.executeJSON(from: url, command: .list(filter: .devicetypes, flags: [.json]))
    }

    public static func listDevices(from url: URL) -> AnyPublisher<DeviceList, SimctrlError> {
        CommandExecutor.executeJSON(from: url, command: .list(filter: .devices, search: .available, flags: [.json]))
    }

    public static func listRuntimes(from url: URL) -> AnyPublisher<RuntimeList, SimctrlError> {
        CommandExecutor.executeJSON(from: url, command: .list(filter: .runtimes, flags: [.json]))
    }


}
