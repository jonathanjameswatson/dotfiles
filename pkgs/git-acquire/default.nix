{ lib, python3Packages }:
with python3Packages; buildPythonApplication rec {
  pname = "git-acquire";
  version = "0.1.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "ThoQAowv1RvU45tl66z+WoYSn29DdCGajJP33RC5BEk=";
  };
  format = "pyproject";
  doCheck = false;
  buildInputs = [
    setuptools
  ];
}
