//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.
// limitations under the License.

let simpleTreeSon = """
    // Copyright (c) <YEAR> <AUTHOR>

    import CmdArgLibCore
    import CmdArgLibMacros
    import CmdArgLibHelpScreen COMPLETION_IMPORT_LINE

    struct Son {COMPLETION_GENERATOR_LINES

        @CommandNodeMacro(shadowGroups: ["lower upper"], synopsis: "Simulate son speaking.")
        static func son(
            l lower: Flag,
            u upper: Flag,
            h__help: MetaFlag = MetaFlag(helpElements: helpElements)
        ) {
            var text = "I want to play chess with my sister."
            if lower { text = text.lowercased() }
            if upper { text = text.uppercased() }
            print(text)
        }

        private static let helpElements: [ShowElement] = [
            .text("DESCRIPTION\\n", "Simulate son speaking."),
            .synopsis("\\nUSAGE\\n"),
            .text("\\nOPTIONS"),
            .parameter("lower", "Lowercase the output"),
            .parameter("upper", "Uppercase the output"),
            .parameter("h__help", "Show help information"),
            .text("\\nNOTE\\n", "The $L{lower} and $L{upper} options shadow each other."),
        ]
    }
    """

let minimalSimpleTreeSon = simpleTreeSon
