//  Copyright (c) 2025-2026 Peter Buenafuente Summerland.
//  All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this
//  file, You can obtain one at https://mozilla.org/MPL/2.0.


struct GlobalOptions {

    static let manpageFlag = "--generate-manpage"
    static let defaultReleaseDir = ".build/release"
    static let defaultProductDir = "~/.local/bin"
    static let defaultManpageDir = "~/.local/share/man/man1"
    static let defaultFishDir = "~/.config/fish/completions"
    static let defaultZshDir = "~/.config/zsh/completions"


    let releaseDir: ReleaseDirectory
    let productDir: ProductDirectory
    let manpageDir: ManpageDirectory
    let fishDir: FishDirectory
    let zshDir: ZshDirectory

    init(releaseDir: ReleaseDirectory,
         productDir: ProductDirectory,
         manpageDir: ManpageDirectory,
         fishDir: FishDirectory,
         zshDir: ZshDirectory) {
        self.releaseDir = releaseDir
        self.productDir = productDir
        self.manpageDir = manpageDir
        self.fishDir = fishDir
        self.zshDir = zshDir
    }
}
