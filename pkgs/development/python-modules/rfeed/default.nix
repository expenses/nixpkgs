{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, lxml
}:

buildPythonPackage rec {
  pname = "rfeed";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qpUG8oZrdPWjItOUoUpjwZpoJcLZR1X/GdRt0eJDSBk=";
  };

  meta = with lib; {
    description = "Extensible RSS 2.0 Feed Generator written in Python.";
    downloadPage = "https://github.com/svpino/rfeed/releases";
    homepage = "https://github.com/svpino/rfeed";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}

