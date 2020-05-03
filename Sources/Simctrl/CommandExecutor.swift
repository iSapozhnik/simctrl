//
//  File.swift
//  
//
//  Created by Ivan Sapozhnik on 27.09.19.
//

import Foundation
import CombineX

extension JSONDecoder: TopLevelDecoder {}

fileprivate extension Process {
    @objc
    static func execute(_ command: String, arguments: [String]) -> Data? {
        let task = Process()
        task.launchPath = command
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            return data
        } catch {
            return nil
        }
    }

    @objc
    static func executeProcess(_ command: String, arguments: [String]) -> Process? {
        let task = Process()
        task.launchPath = command
        task.arguments = arguments


        do {
            try task.run()
            task.waitUntilExit()
            return task
        } catch {
            return nil
        }
    }
}

struct CommandExecutor {
    static func executeAcceptXcode(from url: URL, completion: @escaping (Result<Data, SimctrlError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var xcodebuildUrl = url
            xcodebuildUrl.appendPathComponent("Contents/Developer/usr/bin/xcodebuild")
            if let data = Process.execute(xcodebuildUrl.path, arguments: ["-license", "accept"]) {
                completion(.success(data))
            } else {
                completion(.failure(SimctrlError.missingCommand))
            }
        }
    }

    static func execute(from url: URL, arguments: [String], completion: @escaping (Result<Data, SimctrlError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            var simctilUrl = url
            simctilUrl.appendPathComponent("Contents/Developer/usr/bin/simctl")
            if let data = Process.execute(simctilUrl.path, arguments: arguments) {
                completion(.success(data))
            } else {
                completion(.failure(SimctrlError.missingCommand))
            }
        }
    }

    static func executeProcess(from url: URL, command: Command) -> Process? {
        var simctilUrl = url
        simctilUrl.appendPathComponent("Contents/Developer/usr/bin/simctl")
        return Process.executeProcess(simctilUrl.path, arguments: command.arguments)
    }

    static func execute(from url: URL, arguments: [String]) -> PassthroughSubject<Data, SimctrlError> {
        let publisher = PassthroughSubject<Data, SimctrlError>()

        execute(from: url, arguments: arguments) { result in
            switch result {
            case .success(let data):
                publisher.send(data)
                publisher.send(completion: .finished)
            case .failure(let error):
                publisher.send(completion: .failure(error))
            }
        }

        return publisher
    }

    static func execute(from url: URL, command: Command, completion: ((Result<Data, SimctrlError>) -> Void)? = nil) {
        execute(from: url, arguments: command.arguments, completion: completion ?? { _ in })
    }

    static func executeJSON<T: Decodable>(from url: URL, command: Command) -> AnyPublisher<T, SimctrlError> {
        executeAndDecode(from: url, arguments: command.arguments, decoder: JSONDecoder())
    }

    static func executeAndDecode<Item: Decodable, Decoder: TopLevelDecoder>(from url: URL, arguments: [String],
                                                                                    decoder: Decoder) -> AnyPublisher<Item, SimctrlError> where Decoder.Input == Data {
        execute(from: url, arguments: arguments)
            .decode(type: Item.self, decoder: decoder)
            .mapError({ error -> SimctrlError in
                if error is DecodingError {
                    return .missingOutput
                } else if let command = error as? SimctrlError {
                    return command
                } else {
                    return .unknown(error)
                }
            })
            .eraseToAnyPublisher()
    }
}
