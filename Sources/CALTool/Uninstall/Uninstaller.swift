//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import Foundation

struct Uninstaller {
    let releaseDirURL: URL
    let productDirURL: URL
    let manpageDirURL: URL
    let fishDirURL: URL
    let zshDirURL: URL

    init(globalOptions go: GlobalOptions)
    {
        self.releaseDirURL = urlOf(go.releaseDir)
        self.productDirURL = urlOf(go.productDir)
        self.zshDirURL = urlOf(go.zshDir)
        self.fishDirURL = urlOf(go.fishDir)
        self.manpageDirURL = urlOf(go.manpageDir)
    }

    init(
        releaseDir: ReleaseDirectory?, productDir: ProductDirectory,
        manpageDir: ManpageDirectory, fishDir: FishDirectory, zshDir: ZshDirectory)
    {
        self.releaseDirURL = urlOf(releaseDir!)
        self.productDirURL = urlOf(productDir)
        self.zshDirURL = urlOf(zshDir)
        self.fishDirURL = urlOf(fishDir)
        self.manpageDirURL = urlOf(manpageDir)
    }
}

extension Uninstaller {

    /// Uninstall the indicated files
    /// - Parameters:
    ///   - names: names of files to remove
    ///   - confirmationLimit: If nil, no confirmation required. Else, if more than this limi, confrim  all at once.
    ///
    func uninstall(_ specificNames: [String], confirmEach: Bool, confirmEachLimit: Int?) async throws {
        var output: [String] = []
        try await validateParameters()
        let fm = FileManager.default
        let productDir = productDirURL.path
        var names = specificNames
        if names.isEmpty {
            names = try namesOfExecutableFilesIn(releaseDirURL)
        }
        var errorMessages: [String] = []
        validateUninstallNames(names, &errorMessages)
        if let confirmEachLimit, confirmEachLimit < 1 {
            errorMessages.append("The value for $E{confirmEachLimit} must be positive")
        }
        if !errorMessages.isEmpty {
            throw Exception.errors(errorMessages)
        }

        var productNames: [String] = []
        if let confirmEachLimit, names.count > confirmEachLimit {
            let ok = askForConfirmation(question: "Remove \(names.count) products?")
            if ok { productNames = names }
        }
        else if confirmEach {
            for name in names {
                let ok = askForConfirmation(question: "Remove \(name)?")
                if ok { productNames.append(name) }
            }
        }
        else {
            productNames = names
        }

        productNames.sort { $0 < $1 }
        for productName in productNames {
            output.append("\(productName)")
            let installedURL = productDirURL.appending(path: productName)
            try? fm.removeItem(at: installedURL)
            output.append("    uninstalled \"\(productName)\" in \(productDir)")
            try await uninstallFishCompletionScript(for: productName, &output)
            try await uninstallZshCompletionScript(for: productName, &output)
            try await uninstallManpages(for: productName, &output)
        }
        if !output.isEmpty {
            throw Exception.stdout(output.joined(separator: "\n"))
        }
    }

    func manpageName(of url: URL, for productName: String) -> String? {
        let parts = url.pathComponents
        guard let name = parts.last, name.hasSuffix(".1"), name.hasPrefix(productName) else { return nil }
        return name
    }

    // Uninstalls all whose name matches productName*
    func uninstallManpages(for productName: String, _ output: inout [String]) async throws {
        let fm = FileManager.default
        var names = try fm.contentsOfDirectory(atPath: manpageDirURL.path)
            .map { URL(filePath: $0) }
            .compactMap { manpageName(of: $0, for: productName) }
        names.sort(by: >)
        for name in names {
            let path = manpageDirURL.appending(path: name).path
            if fm.fileExists(atPath: path) {
                try? fm.removeItem(atPath: path)
                output.append("    uninstalled \"\(name)\" in \(manpageDirURL.path)")
            }
        }
    }

    func uninstallFishCompletionScript(for productName: String, _ output: inout [String]) async throws {
        let fm = FileManager.default
        let scriptPath = fishDirURL.appending(path: "\(productName).fish").path
        if fm.fileExists(atPath: scriptPath) {
            try? fm.removeItem(atPath: scriptPath)
            output.append("    uninstalled \"\(productName).fish\" in \(fishDirURL.path)")
        }
    }

    func uninstallZshCompletionScript(for productName: String, _ output: inout [String]) async throws {
        let fm = FileManager.default
        let scriptPath = zshDirURL.appending(path: "_\(productName)").path
        if fm.fileExists(atPath: scriptPath) {
            try? fm.removeItem(atPath: scriptPath)
            output.append("    uninstalled \"_\(productName)\" in \(zshDirURL.path)")
        }
    }
}

extension Uninstaller {

    func validateParameters() async throws {
        var errors: [String] = []
        var isDirectory: ObjCBool = false
        func check(_ dirURL: URL) {
            let dirPath = dirURL.path
            let exists = FileManager.default.fileExists(atPath: dirPath, isDirectory: &isDirectory)
            if !(exists && isDirectory.boolValue) {
                errors.append("Not a directory: \(dirPath).")
            }
        }
        check(releaseDirURL)
        check(productDirURL)
        if !errors.isEmpty {
            throw Exception.errors(errors)
        }
    }

    func validateUninstallNames(_ names: [String], _ errorMessages: inout [String]) {
        if names.isEmpty { return }
        let fm = FileManager.default
        let productDir = productDirURL.path
        for name in names {
            let namePath = productDirURL.appending(path: name).path
            if !fm.fileExists(atPath: namePath) {
                errorMessages.append("Could not find \(name) in \(productDir)")
            }
        }
    }
}

/// Asks the user for confirmation in the terminal.
/// - Parameter question: The prompt to display.
/// - Returns: True if user enters 'y' or 'yes', false otherwise.
func askForConfirmation(question: String) -> Bool {
    print("\(question) (y/n): ", terminator: "")
    guard let response = readLine() else {
        return false  // Handle empty input or EOF
    }
    let allowedResponses = ["y", "yes"]
    return allowedResponses.contains(response.lowercased())
}
