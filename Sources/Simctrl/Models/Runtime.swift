//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 13.03.20.
//

import Foundation

public struct RuntimeList: Decodable {
    public let runtimes: [Runtime]
}

public struct Runtime: Decodable, Hashable, Identifiable {
    static let unknown = Runtime(buildversion: "", identifier: "Unknown", version: "0.0.0", isAvailable: false, name: "Default OS")
    static let runtimeRegex = try? NSRegularExpression(pattern: #"^com\.apple\.CoreSimulator\.SimRuntime\.([a-z]+)-([0-9-]+)$"#, options: .caseInsensitive)

    public let buildversion: String
    public let identifier: String
    public let version: String
    public let isAvailable: Bool
    public let name: String

    public var id: String { identifier }

    var supportedFamilies: Set<DeviceFamily> {
        if name.hasPrefix("iOS") {
            return [.iPhone, .iPad]
        } else if name.hasPrefix("watchOS") {
            return [.watch]
        } else if name.hasPrefix("tvOS") {
            return [.tv]
        } else {
            return []
        }
    }

    /// The user-visible description of the runtime.
    var description: String {
        if buildversion.isEmpty == false {
            return "\(name) (\(buildversion))"
        } else {
            return "\(name)"
        }
    }

    /// Creates a Runtime when we know all its data.
    public init(buildversion: String, identifier: String, version: String, isAvailable: Bool, name: String) {
        self.buildversion = buildversion
        self.identifier = identifier
        self.version = version
        self.isAvailable = isAvailable
        self.name = name
    }

    /// Creates a Runtime when we know only its identifier; we try to extrapolate properties from that string.
    public init?(runtimeIdentifier: String) {
        guard let match = Runtime.runtimeRegex?.firstMatch(in: runtimeIdentifier, options: [.anchored], range: NSRange(location: 0, length: runtimeIdentifier.utf16.count)) else {
            return nil
        }

        let nsIdentifier = runtimeIdentifier as NSString
        let os = nsIdentifier.substring(with: match.range(at: 1))
        let version = nsIdentifier.substring(with: match.range(at: 2)).replacingOccurrences(of: "_", with: ".")

        self.buildversion = ""
        self.identifier = runtimeIdentifier
        self.version = version
        self.name = "\(os) \(version)"
        self.isAvailable = false
    }
}
