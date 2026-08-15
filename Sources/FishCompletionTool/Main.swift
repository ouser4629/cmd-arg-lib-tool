//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibHelpScreen
import CmdArgLibMacros
import Foundation

typealias CommandCall = String
typealias Commands = String
typealias Subcommands = String
typealias LabelSpec = String
typealias LabelsSpec = String

@main
struct Main {
    
    @CommandNodeMacro(synopsis: "Dispatch completion helper", children: subcommands)
    static func __cal_fish_completion_tool(h__help: MetaFlag = MetaFlag(helpElements: help)) {}

    private static let subcommands = [EnableBasic.commandNode, EnableVariadic.commandNode, EnablePostional.commandNode]

    private static let help: [ShowElement] = [
        .text("DESCRIPTION\n", "Determine if a fish completion suggestion is enabled."),
        .synopsis("\nUSAGE\n", line: ["$_:Command"]),
        .text("\nCOMMANDS"),
        .commandContext(EnableBasic.commandNode.context),
        .commandContext(EnableVariadic.commandNode.context),
        .commandContext(EnablePostional.commandNode.context)
    ]

    static func main() async {
        await runAsMain(commandNode)
    }
}
