{ stdenv, fetchurl, pkgconfig, pcre, libyaml, libpcap, zlib }:

stdenv.mkDerivation rec {
  name = "suricata-${version}";
  version = "3.2.1";

  meta.description = "Network intrusion prevention and detection system (IDS/IPS)";
  meta.homepage = "http://suricata-ids.org/";
  meta.license = stdenv.lib.licenses.gpl2;

  src = fetchurl {
    sha256 = "151rglfnrlgn1qzf1x02g6k7czk185rk5i0zzfr4p00nj3s0q2qf";
    url = "https://www.openinfosecfoundation.org/download/suricata-${version}.tar.gz";
  };

  configureFlags= [ "--enable-pie" ] ;
  enableParallelBuilding = true;
  installTargets = "install install-conf";
  nativeBuildInputs = [ pkgconfig pcre libyaml libpcap zlib ];
}
