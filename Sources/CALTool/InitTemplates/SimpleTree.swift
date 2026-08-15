//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let simpleTreeMain = """
    // Copyright (c) <YEAR> <AUTHOR>

    import CmdArgLibCore
    import CmdArgLibMacros
    import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE

    @main
    struct Main {COMPLETION_GENERATOR_LINES

        @CommandNodeMacro(synopsis: "Simulate children speaking.", children: subcommands)
        static func FUNCTION_NAME( COMPLETION_PARAMETER_LINE
            t__tree tree: MetaFlag = MetaFlag(treeFor: "PRODUCT_NAME", synopsis: "Execute a subcommand."),
            v__version version: MetaFlag = MetaFlag(string: "0.0.1"),
            h__help help: MetaFlag = MetaFlag(helpElements: helpElements)
        ) {}
    
       private static let subcommands = [Son.commandNode, Daughter.commandNode]

        private static let helpElements: [ShowElement] = [
            .text("DESCRIPTION\\n", "Simulate children speaking."),
            .synopsis("\\nUSAGE\\n", line: ["$*", "$_:Subcommand"]),
            .text("\\nOPTIONS"),
            .parameter("version","Print the program's version"),
            .parameter("tree", "Show a hierarchical list of commands"),
            .parameter("help", "Show this help screen"), COMPLETION_SHOW_ELEMENT_LINE
            .text("\\nSUBCOMMANDS"),
            .commandContext(Son.commandNode.context),
            .commandContext(Daughter.commandNode.context),
        ]

        private static func main() async {
            await runAsMain(commandNode)
        }
    }
    """

let minimalSimpleTreeMain = simpleTreeMain
