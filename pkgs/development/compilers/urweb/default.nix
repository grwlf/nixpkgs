{ stdenv, lib, fetchurl, file, openssl, mlton
, mysql, postgresql, sqlite
}:

stdenv.mkDerivation rec {
  name = "urweb-${version}";
  version = "20160805";

  src = fetchurl {
    url = "http://www.impredicative.com/ur/${name}.tgz";
    sha256 = "18sww8an63aqvmnzf55q5vjwd5rlbjnrh8aydm96w5chydxz6ip9";
  };

  buildInputs = [ openssl mlton mysql.client postgresql sqlite ];

  prePatch = ''
    sed -e 's@/usr/bin/file@${file}/bin/file@g' -i configure
  '';

  configureFlags = "--with-openssl=${openssl.dev}";

  preConfigure = ''
    export PGHEADER="${postgresql}/include/libpq-fe.h";
    export MSHEADER="${lib.getDev mysql.client}/include/mysql/mysql.h";
    export SQHEADER="${sqlite.dev}/include/sqlite3.h";

    export CCARGS="-I$out/include \
                   -L${lib.getLib mysql.client}/lib/mysql \
                   -L${postgresql.lib}/lib \
                   -L${sqlite.out}/lib";
  '';

  # Be sure to keep the statically linked libraries
  dontDisableStatic = true;

  meta = {
    description = "Advanced purely-functional web programming language";
    homepage    = "http://www.impredicative.com/ur/";
    license     = stdenv.lib.licenses.bsd3;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
