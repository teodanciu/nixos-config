{pkgs,...}:
{
  home.packages = with pkgs.haskellPackages; [
    stack
    cabal-install
    pkgs.haskell.compiler.ghc922
    apply-refact
    # friendly
    ghcid
    hasktags
    hlint
    hoogle
    ormolu
    # profiteur
    # profiterole
    stylish-haskell
  ];
}
