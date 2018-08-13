//
//  EditCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/27.
//

import Result
import Foundation
import Commandant
import Files
import PathKit

struct EditCommand: CommandProtocol {

    let verb: String = "edit"
    let function: String = "Edit the IBLinterfile.swift"

    func run(_ options: NoOptions<CommandantError<()>>) -> Result<(), CommandantError<()>> {
        let ibLinterfile = Runtime.ibLinterfile.exists ? Runtime.ibLinterfile : try! createIBLinterfile()
        try! Runtime.resolvePackages(ibLinterfile: ibLinterfile)
        guard let dylib = Runtime.dylibPath() else {
            print("Could not find a libIBLinter to link against at any of: \(Runtime.potentialFolders)")
            return Result.failure(.commandError(()))
        }
        let arguments = CommandLine.arguments
        let scriptManager = try! Runtime.getScriptManager()
        let script = try! scriptManager.script(atPath: ibLinterfile.string, allowRemote: true)
        let xcodeprojPath = try! script.setupForEdit(arguments: arguments)

        try! addLibPathToXcodeProj(xcodeprojPath: xcodeprojPath, lib: dylib.string)
        try! script.watch(arguments: arguments)
        return .success(())
    }

    func addLibPathToXcodeProj(xcodeprojPath: String, lib: String) throws -> Void {
        let pbxproj = try File(path: xcodeprojPath  + "project.pbxproj")
        let content = try pbxproj.readAsString()
        let before = "-DXcode\","
        let after = "-DXcode\", \"-I\", \"\(lib)\", \"-L\", \"\(lib)\""
        let newContent = content.replacingOccurrences(of: before, with: after)

        try pbxproj.write(string: newContent)
    }

    func createIBLinterfile() throws -> Path {
        let template = "import IBLinter \nlet linter = IBLinter()"
        let data = template.data(using: .utf8)!
        let pathString = try FileSystem().createFile(at: Runtime.ibLinterfile.string, contents: data).path
        return Path(pathString)
    }
}
