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

struct EnablePostional {

    @CommandNodeMacro(synopsis: "Test if can suggest completion for a positional type.")
    static func positional(
        c commandCall: CommandCall,
        _rc_ requiredCommandsSpec: Commands,
        _sc_ subcommandsSpec: Subcommands,
        _vls_ variadicLabelsSpec: LabelsSpec,
        h__help: MetaFlag = MetaFlag(helpElements: help),
    )  {
        if !commandAreOK(c: commandCall, requiredCommandsSpec, subcommandsSpec) {
            exit(EXIT_FAILURE)
        }
        let variadicLabelSpecs = variadicLabelsSpec.components(separatedBy: " ").filter { !$0.isEmpty }
        for labelSpec in variadicLabelSpecs {
            if lastLabeIn(commandCall, matches: labelSpec) {
                exit(EXIT_FAILURE)
            }
        }
        exit(EXIT_SUCCESS)
    }

    static private let help: [ShowElement] = [
        .text("DESCRIPTION\n", "Test if can suggest completion for a positional type."),
        .synopsis("\nUSAGE\n"),
        .text("\nPARAMETERS"),
        .parameter("commandCall","Command line words up to cursor - (commandline -opc)"),
        .parameter("requiredCommandsSpec","Required preceding commands, separated by whitespace"),
        .parameter("subcommandsSpec","Current command's subcommands, seperated by whitespace."),
        .parameter("variadicLabelsSpec", "The label specs of all variadic parameters"),
        .parameter("h__help", "Show help information."),
    ]
}
