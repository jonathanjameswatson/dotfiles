{
  lib,
  python3Packages,
  git-acquire-src,
}:
with python3Packages;
  buildPythonApplication rec {
    pname = "git-acquire";
    version = "0.1.0";
    src = git-acquire-src;
    format = "pyproject";
    doCheck = false;
    buildInputs = [
      setuptools
    ];
  }
