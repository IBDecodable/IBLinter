//
//  Runner.swift
//  iblinter
//
//  Created by SaitoYuta on 2018/05/22.
//

import Result
import Foundation
import PathKit
import Files
import IBLinterKit

class IBLinterRunner {

    enum Error: Swift.Error {
    }

    let ibLinterfile: Path
    init(ibLinterfile: Path) {
        self.ibLinterfile = ibLinterfile
    }

    func run() -> Result<(), IBLinterError> {
        guard let dylib = Runtime.libPath() else {
            return .failure(.dylibNotFound(potentialFolders: Runtime.potentialFolders))
        }

        let resolveResult = Result(attempt: { try Runtime.resolvePackages(ibLinterfile: ibLinterfile) })
            .mapError { IBLinterError.packageManagerFailed($0.error) }
        return resolveResult.flatMap { marathonPath in
            let process = Process()
            let swift = which("swift")
            let outputPipe = Pipe()
            process.standardOutput = outputPipe
            process.launchPath = swift.string
            process.arguments = arguments(dylibPath: dylib, marathonLibPath: marathonPath)

            process.launch()
            process.waitUntilExit()
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8)!
            print(output)
            if process.terminationStatus == EXIT_SUCCESS {
                return .success(())
            } else {
                exit(process.terminationStatus)
            }
        }
    }


    private func which(_ command: String) -> Path {
        let process = Process()
        process.launchPath = "/bin/sh"
        process.arguments = ["-l", "-c", "which \(command)"]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        process.waitUntilExit()
        let outputData = pipe.fileHandleForReading.readDataToEndOfFile()
        guard var pathString = String(data: outputData, encoding: .utf8) else {
            exit(1)
        }
        if pathString.count > 0 {
            pathString.removeLast()
        }
        return Path(pathString)
    }

    private func arguments(dylibPath: Path, marathonLibPath: Path,
                   commandLineArguments: [String] = CommandLine.arguments) -> [String] {
        let artifactPaths = [".build/debug", ".build/release"]
        var arguments = [
            "-L", dylibPath.string,
            "-I", dylibPath.string,
            "-lIBLinter"
        ]
        if let marathonLibPath = artifactPaths.map({ marathonLibPath + $0 }).first(where: { $0.exists }) {
            arguments += [
                "-L", marathonLibPath.string,
                "-I", marathonLibPath.string,
                "-lMarathonDependencies",
            ]
        }
        arguments += [ibLinterfile.string]
        arguments += Array(commandLineArguments.dropFirst())
        return arguments
    }
}
