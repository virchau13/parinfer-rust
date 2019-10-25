{ nixpkgs ? (import ./nixpkgs.nix), ... }:
let
  pkgs = import nixpkgs { config = {}; };
  parinfer-rust = pkgs.callPackage ./derivation.nix {};
in {
  vim-tests = pkgs.stdenv.mkDerivation {
    name = "parinfer-rust-vim-tests";
    src = ./tests/vim;
    buildPhase = ''
      LC_ALL=en_US.UTF-8 \
        LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive \
        VIM_TO_TEST=${pkgs.vim}/bin/vim \
        PLUGIN_TO_TEST=${parinfer-rust}/share/vim-plugins/parinfer-rust \
        ${pkgs.vim}/bin/vim --clean -u run.vim
    '';
    installPhase = ''
      touch $out
    '';
  };

  neovim-tests = pkgs.stdenv.mkDerivation {
    name = "parinfer-rust-neovim-tests";
    src = ./tests/vim;
    buildPhase = ''
      LC_ALL=en_US.UTF-8 \
        LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive \
        VIM_TO_TEST=${pkgs.neovim}/bin/nvim \
        PLUGIN_TO_TEST=${parinfer-rust}/share/vim-plugins/parinfer-rust \
        ${pkgs.vim}/bin/vim --clean -u run.vim
    '';
    installPhase = ''
      touch $out
    '';
  };
}
