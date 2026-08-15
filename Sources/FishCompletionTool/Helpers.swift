//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import Foundation

func commandAreOK(
    c commandCall: CommandCall,
    _ requiredCommandsSpec: Commands,
    _ subcommandsSpec: Subcommands,
) -> Bool {
    let words = commandCall.components(separatedBy: .whitespacesAndNewlines)
    let requiredCommands = requiredCommandsSpec.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
    let subcommands = subcommandsSpec.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }

    // Run while matching words to required commands
    var requiredNdx = 0
    var wordsNdx = 0
    while requiredNdx < requiredCommands.count {
        if wordsNdx >= words.count {
           return false  //could not match all required
        }
        if words[wordsNdx] == requiredCommands[requiredNdx] {
            requiredNdx += 1
        }
        wordsNdx += 1
    }

    // wordsNdx points to first word after last required command
    if !subcommands.isEmpty {
        while wordsNdx < words.count {
            let word = words[wordsNdx]
            if subcommands.contains(word) {
                return false
            }
            wordsNdx += 1
        }
    }
    return true
}

/// Assumes the label is for an arugment that takes a value
func lastLabeIn(_ commandCall: CommandCall, matches labelSpec: LabelSpec) -> Bool {
    let parts = commandCall.components(separatedBy: .whitespacesAndNewlines)
    let (shortLabel, oldStyleLabel, longLabel) = makeLabelTriple(labelSpec)
    var indexOfLastLabel = -1
    var indexOfLastLMatichingLabel: Int?
    for (index, part) in parts.enumerated() {
        var labelFound = false
        if part == "--" {
            break
        }
        if !part.hasPrefix("-") || part == "-" {
            continue
        }
        indexOfLastLabel = index

        if let shortLabel {
            if !part.hasPrefix("--"), part.contains(shortLabel.last!) {
                labelFound = true
            }
        }
        if let longLabel {
            if longLabel == part {
                labelFound = true
            } else if let i = part.firstIndex(of: "="), longLabel == part[part.startIndex..<i] {
                labelFound = true
            }
        }
        if let oldStyleLabel {
            if oldStyleLabel == part {
                labelFound = true
            } else if let i = part.firstIndex(of: "="), oldStyleLabel == part[part.startIndex..<i] {
                labelFound = true
            }
        }
        if labelFound {
            indexOfLastLMatichingLabel = index
        }
    }
    return indexOfLastLMatichingLabel == indexOfLastLabel
}
