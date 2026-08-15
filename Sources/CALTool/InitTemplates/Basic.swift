//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let basicMain = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE

@main
struct Main {COMPLETION_GENERATOR_LINES
    typealias Count = Int
    enum Animal: String, CmdArgEnum { case bear, fox, wolf }

    @MainFunctionMacro
    static func FUNCTION_NAME(COMPLETION_PARAMETER_LINE
        i__index index: Flag = false,
        c__count count: Count = 1,
        _ animals: [Animal], 
        v__version version: MetaFlag = MetaFlag(string: "version 0.1.0"),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
    ) throws {
        let text = try showAnimals(animals, count: count, index: index)
        throw Exception.stdout(text)
    }

    static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\\n", "Print lines containing the names of animals."),
        .synopsis("\\nUSAGE\\n"),
        .text("\\nARGUMENT"),
        .parameter("animals", "The name of an animal (can be repeated)", .list(Animal.cases)),
        .text("\\nOPTIONS"),
        .parameter("count", "The number of times to repeat the line"),
        .parameter("index", "Prefix each line with an index"),
        .parameter("help", "Show this help message"),
        .parameter("version", "Show version information"), COMPLETION_SHOW_ELEMENT_LINE
        .text("\\nNOTES\\n", note1),
        .text("\\n", note2),
    ]

    static let note1 = \"\"\"
        The available animals are \\(Animal.casesJoinedWith("and")).
        \"\"\"

    static let note2 = \"\"\"
        The value $T{count}, if specified, must be between 1 and 3.
        \"\"\"
}

extension Main {
    static func showAnimals(_ animals: [Animal], count: Count, index: Bool) throws -> String {
        if count < 1 || count > 3 {
            throw Exception.error("$T{count} must be between 1 and 3.")
        }
        let animalsString = string(of: animals)
        var lines: [String] = []
        for i in 1...count {
            let indexString = index ? "\\(i): " : ""
            lines.append(indexString + animalsString)
        }
        return lines.joined(separator: "\\n")
    }

    static func string(of animals: [Animal]) -> String {
        animals.map { $0.rawValue }.joinedWith("and")
    }
}
"""

let minimalBasicMain = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE

@main
struct Main {COMPLETION_GENERATOR_LINES
    @MainFunctionMacro
    static func FUNCTION_NAME(COMPLETION_PARAMETER_LINE
        v__version version: MetaFlag = MetaFlag(string: "version 0.1.0"),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
    ) throws {
        throw Exception.stdout("A gnu is an animal.")
    }

    static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\\n", "Explain GNU."),
        .synopsis("\\nUSAGE\\n"),
        .text("\\nOPTIONS"),
        .parameter("help", "Show this help message"),
        .parameter("version", "Show version information"), COMPLETION_SHOW_ELEMENT_LINE
        .text("\\nNOTES\\n", "A gnu is an animal."),
    ]
}
"""
