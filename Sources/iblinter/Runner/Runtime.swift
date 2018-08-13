//
//  Runtime.swift
//  AEXML
//
//  Created by SaitoYuta on 2018/05/27.
//

import Foundation
import MarathonCore
import PathKit
import Files

public struct Runtime {

    public static let potentialFolders = [
        Path.current + "/Pods/IBLinter/lib",
        Path("/usr/local/lib/iblinter")
    ]

    public static let ibLinterfile = Path("./IBLinterfile.swift")
    static let tmpFolder = ".iblinter-tmp"

    public static func dylibPath() -> Path? {
        guard let libPath = potentialFolders.first(where: { ($0 + "libIBLinter.dylib").exists }) else {
            return nil
        }
        return libPath
    }

    @discardableResult
    public static func resolvePackages(ibLinterfile: Path) throws -> Path {
        let scriptManager = try getScriptManager(tmpFolder: tmpFolder)
        let importExternalDeps = try ibLinterfile.read().components(separatedBy: .newlines)
            .filter { $0.hasPrefix("import") && $0.contains("package: ") }
        let tmpFileName = "_iblinter_imports.swift"
        try Folder(path: tmpFolder).createFileIfNeeded(withName: tmpFileName)
        let tmpFile = try File(path: "\(tmpFolder)/\(tmpFileName)")
        try tmpFile.write(string: importExternalDeps.joined(separator: "\n"))

        let script = try scriptManager.script(atPath: tmpFile.path, allowRemote: true)
        try script.build()

        return Path(script.folder.path)
    }

    static func getScriptManager(tmpFolder: String = tmpFolder) throws -> ScriptManager {
        let folder = tmpFolder
        let printFunction = { print($0) }
        let vPrintFunction = { (messageExpression: () -> String) in }

        let printer = Printer(
            outputFunction: printFunction,
            progressFunction: vPrintFunction,
            verboseFunction: vPrintFunction
        )
        let fileSystem = FileSystem()

        let rootFolder = try fileSystem.createFolderIfNeeded(at: folder)
        let packageFolder = try rootFolder.createSubfolderIfNeeded(withName: "Packages")
        let scriptFolder = try rootFolder.createSubfolderIfNeeded(withName: "Scripts")

        let packageManager = try PackageManager(folder: packageFolder, printer: printer)
        let config = ScriptManager.Config(prefix: "package: ", file: "Dangerplugins")

        return try ScriptManager(folder: scriptFolder, packageManager: packageManager, printer: printer, config: config)
    }

}
