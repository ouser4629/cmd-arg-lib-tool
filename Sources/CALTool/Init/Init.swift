//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.

import CmdArgLibCore
import CmdArgLibMacros
import CmdArgLibHelpScreen
import CmdArgLibManpage
import Foundation

typealias Directory = String

struct Init {

    @CommandNodeMacro<GlobalOptions>(
        synopsis: "Initialize a new package."
    )
    static func `init`(
        h__help help: MetaFlag = MetaFlag(helpElements: helpElements),
        c__withCompletion completion: Flag,
        l__withLess less: Flag,
        d__directory directory: Directory? = nil,
        n__name productName: Product? = nil,
        t__template template: Template,
        generateManpage: MetaFlag = MetaFlag(manpageElements: manpageElements),
        state: [GlobalOptions]) async throws -> [GlobalOptions]
    {
        if template == .opaque && completion {
            throw Exception.error("$J{completion} is not supported for opaque templates")
        }
        if less {
            switch template {
            case .opaque, .basic, .testing:
                break
            default:
                throw Exception.error("$J{less} is not supported for the \(template)")
            }
        }
        let initializer = try Initializer(template: template, product: productName, populate: !less, completion: completion, directory: directory)
        try initializer.initialize()
        return []
    }

    private static let helpElements: [ShowElement] = [
        .text("DESCRIPTION\n", "Initialize a Swift package containing an executable product."),
        .synopsis("\nUSAGE\n", line: ["$*", "!generateManpage"]),
        .text("\nOPTIONS"),
        .parameter("completion", completionNote),
        .parameter("less", lessNote),
        .parameter("help", "Show this help screen"),
        .parameter("directory", directoryNote, .path),
        .parameter("productName", "The name of the product (default: the package name in kebab-case)"),
        .parameter("template", "The template to use", .list(Template.cases)),
        .text("\nTEMPLATES"),
        .pseudoParameter("opaque", "A product without a help screen"),
        .pseudoParameter("basic", "A product with a help screen"),
        .pseudoParameter("testing", "A product with unit tests"),
        .pseudoParameter("manpage", "A product with a manual page"),
        .pseudoParameter("simple-tree", "A product with commands and subcommands"),
        .pseudoParameter("stateful-tree", "A product with stateful commands and subcommands"),
        .text("\nNOTES\n", packageNameNote),
    ]

    private static let completionNote = """
        Add zsh and fish completion generation support to the executable product.
        Does not apply to the "opaque" template
        """

    private static let lessNote = """
        Use a template variant with fewer example parameters. Applies only to
        "opaque", "basic" and "testing"
        """

    private static let productNameNote = """
       The name of the product. If not specified, the name defaults to the kebab-case
       form of the package name.
       """

    private static let directoryNote = """
        The directory containing the new package (default: the current directory). If the 
        $E{directory} is specified and does not exist, it will be created
        """

    private static let packageNameNote = """
        The package name defaults to the last component of the specified directory path.
        
        """
}

extension Init {
    
    private static let manpageElements: [ShowElement] = [
        .prologue(description: "initialize a Swift package containing an executable product"),
        .synopsis(lines: [
            ["$*", "!generateManpage"],
            ["$generateManpage:Flag="]
        ]),
        .mdoc("DESCRIPTION", manpageDescriptionNote1),
        .mdoc("","The following options are available:"),
        .parameter("completion", completionNote),
        .parameter("directory", directoryNote, .path),
        .parameter("generateManpage", "Generate the mdoc source for this manual page and write it to standard output"),
        .parameter("help", "Show a help screen"),
        .parameter("less", lessNote),
        .parameter("productName", productNameNote),
        .parameter("template", "The template to use"),
        .mdoc("", packageNameNote),
        .mdoc("TEMPLATES",templateNote),
        .pseudoParameter("opaque", "A product without help screen generation"),
        .pseudoParameter("basic", "A product with a basic help screen"),
        .pseudoParameter("testing", "A product with unit testing"),
        .pseudoParameter("manpage", "A product with manual page generation."),
        .pseudoParameter("simple-tree", "A product with commands and subcommands"),
        .pseudoParameter("stateful-tree", "A product with stateful commands and subcommands"),
        .mdoc("", Main.exitStatus),
        .mdoc("", seeAlso),
        .mdoc("", Main.authors),
    ]

    private static let templateNote = """
        Templates provide starting points for different executable product configurations.
        All generated products can generate help screens 
        except those based on the "opaque" template. Only products based on the "manpage" template 
        can generate manual pages.
        """

    private static let manpageDescriptionNote1 = """
        The $F{-} utility initializes a package containing an executable product based on a given $E{template}.
        Some templates also have variants with fewer example parameters.
        """

    private static let seeAlso = """
        .Sh SEE ALSO
        .Xr caltool 1 ,
        .Xr caltool-install 1 ,
        .Xr caltool-uninstall 1
        """
}
