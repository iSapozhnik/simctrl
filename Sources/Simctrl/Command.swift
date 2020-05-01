//
//  Command.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation

struct Command {
    let arguments: [String]

    private init(_ subcommand: String, arguments: [String]) {
        self.arguments = [subcommand] + arguments
    }

    /// Open a URL in a device.
    static func openURL(deviceId: String?, url: String) -> Command {
        Command("openurl", arguments: [deviceId ?? "booted", url])
    }

    /// Boot a device.
    static func boot(deviceId: String) -> Command {
        Command("boot", arguments: [deviceId])
    }

    /// List available devices, device types, runtimes, or device pairs.
    static func list(filter: List.Filter? = nil, search: List.Search? = nil, flags: [List.Flag] = []) -> Command {
        var arguments: [String] = []
        if let filter = filter {
            arguments.append(contentsOf: filter.arguments)
        }
        if let search = search {
            arguments.append(contentsOf: search.arguments)
        }
        return Command("list", arguments: arguments + flags.flatMap { $0.arguments })
    }
}

extension Command {
    public enum List {
        public enum Filter: String {
            case devices
            case devicetypes
            case runtimes
            case pairs

            var arguments: [String] {
                return [rawValue]
            }
        }

        enum Search {
            case string(String)
            case available

            var arguments: [String] {
                switch self {
                case .string(let string):
                    return [string]
                case .available:
                    return ["available"]
                }
            }
        }

        public enum Flag: String {
            case json = "-j"
            case verbose = "-v"

            var arguments: [String] {
                [self.rawValue]
            }
        }
    }
}
