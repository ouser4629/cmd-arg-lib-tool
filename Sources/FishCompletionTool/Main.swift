// Copyright (c) 2025-2026 Peter Summerland LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
