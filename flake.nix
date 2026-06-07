{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cargo
            rustc
            rust-analyzer
            rustfmt
            clippy
            nodejs
            pnpm
            pkg-config
            cmake
            gtk3
            webkitgtk_4_1
            libappindicator-gtk3
            librsvg
            alsa-lib
            libxkbcommon
            clang
            xdotool
            xorg.libXtst
            libpulseaudio
            gtk-layer-shell
            wtype
            glslang
            dbus
            vulkan-loader
            vulkan-tools
            vulkan-headers
            shaderc
            llvmPackages.libclang
            gst_all_1.gstreamer
            gst_all_1.gst-plugins-base
            gst_all_1.gst-plugins-good
            gst_all_1.gst-plugins-bad
            gst_all_1.gst-plugins-ugly
            gst_all_1.gst-libav
          ];

          LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
          shellHook = ''
            export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath (with pkgs; [
              gtk3
              webkitgtk_4_1
              libappindicator-gtk3
              librsvg
              alsa-lib
              libxkbcommon
              dbus
              libpulseaudio
              gtk-layer-shell
              vulkan-loader
            ])}:$LD_LIBRARY_PATH
            export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
            export GST_PLUGIN_SYSTEM_PATH_1_0=${pkgs.lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" (with pkgs.gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly gst-libav ])}
          '';
        };
      });
}
