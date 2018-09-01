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
import xcproj

struct EditCommand: CommandProtocol {
    typealias Options = NoOptions<CommandantError<IBLinterError>>

    let verb: String = "edit"
    let function: String = "Edit the IBLinterfile.swift"

    func run(_ options: Options) -> Result<(), CommandantError<IBLinterError>> {
        let ibLinterfile = Runtime.ibLinterfile.exists ? Runtime.ibLinterfile : try! createIBLinterfile()
        try! Runtime.resolvePackages(ibLinterfile: ibLinterfile)
        guard let libPath = Runtime.libPath() else {
            return .failure(.commandError(.dylibNotFound(potentialFolders: Runtime.potentialFolders)))
        }
        let arguments = CommandLine.arguments
        let scriptManager = try! Runtime.getScriptManager()
        let script = try! scriptManager.script(atPath: ibLinterfile.string, allowRemote: true)
        let xcodeprojPath = try! script.setupForEdit(arguments: arguments)

        try! addLibPathToXcodeProj(xcodeprojPath: xcodeprojPath, libPath: libPath)
        try! script.watch(arguments: arguments)
        return .success(())
    }

    func addLibPathToXcodeProj(xcodeprojPath: String, libPath: Path) throws -> Void {
        let xcodeProj = try XcodeProj(pathString: xcodeprojPath)
        let sourceRoot = Path(xcodeprojPath).parent()

        let otherSwiftFlagsKey = "OTHER_SWIFT_FLAGS"
        xcodeProj.pbxproj.objects.buildConfigurations.forEach { (key, configuration)  in
            configuration.buildSettings["LIBRARY_SEARCH_PATHS"] = ["$(inherited)", libPath.string]
            guard let flags = configuration.buildSettings[otherSwiftFlagsKey] as? [String] else {
                return
            }
            configuration.buildSettings[otherSwiftFlagsKey] = flags + ["-I \(libPath.string)", "-L \(libPath.string)"]
        }

        let fileReference = try xcodeProj.pbxproj.objects.addFile(
            at: libPath + Runtime.dylibName, toGroup: xcodeProj.pbxproj.rootGroup,
            sourceRoot: sourceRoot
        )
        guard let target = xcodeProj.pbxproj.objects.targets(named: "IBLinterfile").first?.object else {
            return
        }
        guard let buildFile = xcodeProj.pbxproj.objects
            .addBuildFile(toTarget: target, reference: fileReference.reference) else { return }
        xcodeProj.pbxproj.objects.frameworksBuildPhases.forEach { key, value in
            value.files.append(buildFile.reference)
        }

        try xcodeProj.write(path: Path(xcodeprojPath))
    }

    func createIBLinterfile() throws -> Path {
        let template = "import IBLinter \nlet linter = IBLinter()"
        let data = template.data(using: .utf8)!
        let pathString = try FileSystem().createFile(at: Runtime.ibLinterfile.string, contents: data).path
        return Path(pathString)
    }
}
