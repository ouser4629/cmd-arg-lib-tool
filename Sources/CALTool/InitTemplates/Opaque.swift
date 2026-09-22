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

let opaqueMain = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros COMPLETION_IMPORT_LINE

typealias Count = Int
enum Animal: String, CmdArgEnum { case bear, fox, wolf }

@main
struct Main {
    @MainFunctionMacro
    private static func FUNCTION_NAME(COMPLETION_PARAMETER_LINE
        i index: Flag = false,
        c count: Count = 1,
        a animals: [Animal],
    ) throws {
        try print(showAnimals(animals, count: count, index: index))
    }

    static func showAnimals(_ animals: [Animal], count: Count, index: Bool) throws -> String {
        if count < 1 || count > 3 {
            throw Exception.errors(["$T{count} must be between 1 and 3."])
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

let minimalOpaqueMain = """
// Copyright (c) <YEAR> <AUTHOR>

import CmdArgLibCore
import CmdArgLibMacros

@main
struct Main {
    @MainFunctionMacro
    private static func FUNCTION_NAME(
    ) throws {
        try print(showAnimals())
    }
}

extension Main {
    static func showAnimals() throws -> String {
        "gnu"
    }
}
"""
