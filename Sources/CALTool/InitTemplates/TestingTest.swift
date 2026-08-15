//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

let testingTest = """
    // Copyright (c) <YEAR> <AUTHOR>

    import CmdArgLibCore
    import CmdArgLibTestSupport
    import Testing
    @testable import TARGET_NAMESupport
    
    // These tests do not require CmdArgLibCore or CmdArgLibTestSupport
    struct TARGET_NAMETest {

        @Test func showAnimalsTest() throws {
            var result = try TARGET_NAMESupport.showAnimals([.bear, .fox], count: 1, index: false)
            #expect(result == "bear and fox")

            result = try TARGET_NAMESupport.showAnimals([.bear, .fox], count: 1, index: false, upper: true)
            #expect(result == "BEAR AND FOX")

            result = try TARGET_NAMESupport.showAnimals([.bear, .fox], count: 1, index: false, lower: true)
            #expect(result == "bear and fox")

            result = try TARGET_NAMESupport.showAnimals([.bear, .fox], count: 2, index: true)
            #expect(result == "1: bear and fox\\n2: bear and fox")

            result = try TARGET_NAMESupport.showAnimals([], count: 1, index: false)
            #expect(result == "")
        }
    }
    
    // These require CmdArgLibCore and CmdArgLibTestSupport
    struct TARGET_NAMEOutputTests {

        @Test func simpleInput() {
            let input = "-iuc2 wolf"
            let output = \"\"\"
            1: WOLF
            2: WOLF
            \"\"\"
            let ok = testOutput(of: TARGET_NAMESupport.run, with: input, expecting: output)
            #expect(ok)
        }

        @Test func ErrorsTest() {
            let input = "-iuxyz --count"
            let output = \"\"\"
            Errors:
              unrecognized options: "-x", "-y" and "-z", in "-iuxyz"
              missing expected value after "--count"
              missing value: "<animal>"
            See "PRODUCT_NAME --help" for more information.
            \"\"\"
            let ok = testOutput(of: TARGET_NAMESupport.run, with: input, expecting: output)
            #expect(ok)
        }
    
        /* -- Decomment to see failed test reporting
        // This test will fail because the contrived expected output is purposely incorrect
        @Test func FailedErrorsTest() {
            let input = "-iuxyz --count"
            let output = \"\"\"
            Errors:
              unrecognized options: "-x", "-y" and "-z", in "-iuxyz"
              missing an expected value after "--count"
              missing an "<animal>"
            See "PRODUCT_NAME --help" for more information.
            \"\"\"
            let ok = testOutput(of: TARGET_NAMESupport.run, with: input, expecting: output)
            #expect(ok)
        }
        */
    }
    """


let minimalTestingTest = """
    // Copyright (c) <YEAR> <AUTHOR>

    import Testing

    @testable import TARGET_NAMESupport

    struct TARGET_NAMETest {
        @Test func showAnimalsTest() throws {
            let result = TARGET_NAMESupport.showAnimals()
            #expect(result == "gnu")
        }
    }
    """
