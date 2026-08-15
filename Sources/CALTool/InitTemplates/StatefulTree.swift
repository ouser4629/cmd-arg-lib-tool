//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let statefulTreeMain = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros 
import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE

@main
struct Main {COMPLETION_GENERATOR_LINES

    @CommandNodeMacro<Format>(shadowGroups: ["lower upper"], synopsis: "Simulate children speaking.", children: subcommands)
    static func FUNCTION_NAME(COMPLETION_PARAMETER_LINE
        l__lower lower: Flag,
        u__upper upper: Flag,
        t__tree tree: MetaFlag = MetaFlag(treeFor: "PRODUCT_NAME"), 
        v__version version: MetaFlag = MetaFlag(string: "0.0.1"),
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
        state: [Format]) -> [Format]
    {
        return [Format(upper: upper, lower: lower)]
    }

    private static let subcommands = [Son.commandNode, Daughter.commandNode]

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\\n", "Simulate children speaking."),
        .synopsis("\\nUSAGE\\n", line: ["$*", "$_:Subcommand"]),
        .text("\\nOPTIONS"),
        .parameter("lower","Print ouput in lower case"),
        .parameter("upper","Print ouput in upper case"),
        .parameter("version","Print the program's version"), COMPLETION_SHOW_ELEMENT_LINE
        .parameter("tree", "Show a hierarchical list of commands"),
        .parameter("help", "Show this help screen"),
        .text("\\nSUBCOMMANDS"),
        .commandContext(Son.commandNode.context),
        .commandContext(Daughter.commandNode.context),
        .text("\\nNOTE\\n", "The $L{lower} and $L{upper} options shadow each other."),
    ]

    private static func main() async {
        await runAsMain(commandNode)
    }
}

struct Format {
    let upper: Bool
    let lower: Bool
}
"""

let minimalStatefulTreeMain = statefulTreeMain
