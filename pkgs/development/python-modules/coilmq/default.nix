{ stdenv, buildPythonPackage, fetchPypi
, stompclient, pythondaemon, redis, pid, pytest, six, click, coverage
, sqlalchemy }:

buildPythonPackage rec {
  pname = "CoilMQ";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4cbfeb5ed2459df14902c1380157be6267702b1271682924cd316ccad8a29d1d";
  };

  propagatedBuildInputs = [ stompclient pythondaemon redis pid ];
  buildInputs = [ pytest six click coverage sqlalchemy ];

  # The teste data is not included in the distribution
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Simple, lightweight, and easily extensible STOMP message broker";
    homepage = http://code.google.com/p/coilmq/;
    license = licenses.asl20;
  };
}
