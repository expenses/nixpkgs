{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, lxml
}:

buildPythonPackage rec {
  pname = "rfeed";
  version = "1.1.1";

  src = fetchGit {
    url = "https://github.com/svpino/rfeed";
    rev = "a4ccbcb40eb86d5a4bda26b4f49c3921b39be26e";
  };

  patches = [
    ./fix-tests.patch
  ];

  meta = with lib; {
    description = "Extensible RSS 2.0 Feed Generator written in Python.";
    downloadPage = "https://github.com/svpino/rfeed/releases";
    homepage = "https://github.com/svpino/rfeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}

