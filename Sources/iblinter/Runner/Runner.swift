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
    let ibLinterfile: Path
    init(ibLinterfile: Path) {
        self.ibLinterfile = ibLinterfile
    }

    func run() -> Result<(), ValidateCommand.ClientError> {

        func which(_ command: String) -> Path {
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
            return Path.init(pathString)
        }

        guard let dylib = Runtime.dylibPath() else {
            print("Could not find a libIBLinter to link against at any of: \(Runtime.potentialFolders)")
            exit(1)
        }

        let marathonPath = try! Runtime.resolvePackages(ibLinterfile: ibLinterfile)
        let artifactPaths = [".build/debug", ".build/release"]

        var arguments = [
            "-L", dylib.string,
            "-I", dylib.string,
            "-lIBLinter"
        ]
        if let marathonLibPath = artifactPaths.map({ marathonPath + $0 }).first(where: { $0.exists }) {
            arguments += [
                "-L", marathonLibPath.string,
                "-I", marathonLibPath.string,
                "-lMarathonDependencies",
            ]
        }
        arguments += [ibLinterfile.string]
        arguments += Array(CommandLine.arguments.dropFirst())
        let process = Process()
        let swift = which("swift")
        let inputPipe = Pipe()
        FileHandle.standardInput.writeabilityHandler = {
            inputPipe.fileHandleForWriting.write($0.availableData)
        }
        process.standardInput = inputPipe

        process.launchPath = swift.string
        process.arguments = arguments

        process.launch()
        process.waitUntilExit()
        if process.terminationStatus == 0 {
            return .success(())
        } else {
            exit(process.terminationStatus)
        }
    }
}
