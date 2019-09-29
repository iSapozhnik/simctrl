//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 29.09.19.
//

import Foundation

public struct DeviceDescription {
    public let nameAndStatus: String
    public let id: String
}

// Rewrite with NSScanner?

public class DeviceListParser {

    public func parse(string: String) -> [String: [DeviceDescription]] {
        let lines = string.components(separatedBy: "\n")

        var startIndex = 0
        var endIndex = 0
        for line in lines {
            if line == "== Devices ==", let index = lines.firstIndex(of: line) {
                startIndex = index + 1
            }

            if line == "== Device Pairs ==", let index = lines.firstIndex(of: line) {
                endIndex = index
            }
        }

        let devicesList = lines[startIndex..<endIndex]

        var currentOS = [String: [DeviceDescription]]()
        var currentOSName = ""
        for deviceString in devicesList {
            if deviceString.hasPrefix("--") { // Create device list
                let osName = deviceString.replacingOccurrences(of: "-- ", with: "").replacingOccurrences(of: " --", with: "")
                currentOSName = osName
                currentOS[currentOSName] = [DeviceDescription]()
            } else {
                var devicesForOSName = currentOS[currentOSName]

                let range = NSRange(location: 0, length: deviceString.utf16.count)

                let deviceIdRegex = try! NSRegularExpression(pattern: "[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}")
                let deviceIdToRemoveRegex = try! NSRegularExpression(pattern: "\\s\\([A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}\\)")
                if let matchResult = deviceIdRegex.firstMatch(in: deviceString, options: [], range: range) {
                    let deviceID = deviceString[Range(matchResult.range, in: deviceString)!]
                    var deviceNameAndStatus = deviceIdToRemoveRegex.stringByReplacingMatches(in: deviceString, options: [], range: range, withTemplate: "")
                    deviceNameAndStatus = deviceNameAndStatus.replacingOccurrences(of: "   ", with: "")

                    devicesForOSName?.append(DeviceDescription(nameAndStatus: deviceNameAndStatus, id: String(deviceID)))
                }

                currentOS[currentOSName] = devicesForOSName
            }
        }

        currentOS = currentOS.filter { !$0.value.isEmpty }.filter { $0.key.hasPrefix("iOS") }
        return currentOS
    }
}
