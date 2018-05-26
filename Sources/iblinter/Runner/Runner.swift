//
//  Runner.swift
//  iblinter
//
//  Created by SaitoYuta on 2018/05/22.
//

import Foundation
import PathKit

class IBLinterRunner {
    let ibLinterFile: Path
    init(ibLinterFile: Path) {
        self.ibLinterFile = ibLinterFile
    }

    let potentialFolders = [
        Path.current + "/Pods/IBLinter/lib",
        Path("/usr/local/lib/iblinter")
    ]

    func dylibPath() -> Path? {
        guard let libPath = potentialFolders.first(where: { ($0 + "libIBLinterKit.dylib").exists }) else {
            return nil
        }
        return libPath
    }

    func run() {

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

        guard let dylib = dylibPath() else {
            print("Could not find a libIBLinterKit to link against at any of: \(potentialFolders)")
            exit(1)
        }

        let process = Process()
        let swift = which("swift")
        let arguments = [
            "-L", dylib.string,
            "-I", dylib.string,
            "-lIBLinterKit",
            ibLinterFile.string
        ]
        process.launchPath = swift.string
        process.arguments = arguments

        process.launch()
        process.waitUntilExit()
        exit(process.terminationStatus)
    }
}
