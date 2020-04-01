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
}

struct CommandExecutor {
    static func execute(_ arguments: [String], completion: @escaping (Result<Data, SimctrlError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = Process.execute("/usr/bin/xcrun", arguments: ["simctl"] + arguments) {
                completion(.success(data))
            } else {
                completion(.failure(SimctrlError.missingCommand))
            }
        }
    }

    static func execute(_ arguments: [String]) -> PassthroughSubject<Data, SimctrlError> {
        let publisher = PassthroughSubject<Data, SimctrlError>()

        execute(arguments) { result in
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

    static func execute(_ command: Command, completion: ((Result<Data, SimctrlError>) -> Void)? = nil) {
        execute(command.arguments, completion: completion ?? { _ in })
    }

    static func executeJSON<T: Decodable>(_ command: Command) -> AnyPublisher<T, SimctrlError> {
        executeAndDecode(command.arguments, decoder: JSONDecoder())
    }

    static func executeAndDecode<Item: Decodable, Decoder: TopLevelDecoder>(_ arguments: [String],
                                                                                    decoder: Decoder) -> AnyPublisher<Item, SimctrlError> where Decoder.Input == Data {
        execute(arguments)
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
