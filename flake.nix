{
    description = "flutter devshell";

    inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    outputs =
        { self, nixpkgs }:
        let
            system = "x86_64-linux";
            pkgs = import nixpkgs {
                inherit system;
                config = {
                    allowUnfree = true;
                    android_sdk.accept_license = true;
                };
            };
            buildInputs = with pkgs; [
                kdePackages.qtwayland
                android-tools
                sdkmanager
                mesa-demos
                flutter
                glibc
                zlib
                bzip2
                jdk
            ];
            sdkPath = "$HOME/.android-sdk";
        in
        {
            fonts.packages = with pkgs; [
                noto-fonts
                noto-fonts-cjk-sans
                noto-fonts-emoji
            ];

            devShells.${system}.default = pkgs.mkShell {
                packages = with pkgs; [ pkg-config ];
                inherit buildInputs;
                shellHook = ''
                    export JAVA_HOME=${pkgs.jdk}
                    export ANDROID_SDK_ROOT=${sdkPath}
                    export ANDROID_HOME=$ANDROID_SDK_ROOT
                    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath buildInputs}:$LD_LIBRARY_PATH
                    export PATH=$HOME/.pub-cache/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/build-tools/34.0.0:$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH
                    export QT_QPA_PLATFORM=xcb

                    export CHROME_EXECUTABLE=$(which brave)

                    export FONTCONFIG_PATH="${pkgs.fontconfig.out}/etc/fonts"
                    export XDG_DATA_DIRS="${pkgs.noto-fonts}/share:${pkgs.noto-fonts-cjk-sans}/share:${pkgs.noto-fonts-emoji}/share:$XDG_DATA_DIRS"

                    # ensure writable sdk exists
                    mkdir -p "$ANDROID_SDK_ROOT"
                '';
            };
        };
}
