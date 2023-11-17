with (import <nixpkgs> {});
let
  my-python = pkgs.python3;
  python-with-my-packages = my-python.withPackages (p: with p; [
    numpy
    autopep8 
  ]);
in
mkShell {
  buildInputs = [
    python3
  ];
  shellHook = ''
      PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
      # maybe set more env-vars
    '';
}
