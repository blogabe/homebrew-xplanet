class Cspice < Formula
  desc "Observation geometry system for robotic space science missions"
  homepage "https://naif.jpl.nasa.gov/naif/toolkit.html"
  url "https://naif.jpl.nasa.gov/pub/naif/toolkit/C/MacIntel_OSX_AppleC_64bit/packages/cspice.tar.Z"
  mirror "https://dl.bintray.com/homebrew/mirror/cspice-66.tar.Z"
  version "66"
  sha256 "f5d48c4b0d558c5d71e8bf6fcdf135b0943210c1ff91f8191dfc447419a6b12e"

  conflicts_with "openhmd", because: "both install `simple` binaries"
  conflicts_with "libftdi0", because: "both install `simple` binaries"
  conflicts_with "enscript", because: "both install `states` binaries"
  conflicts_with "fondu", because: "both install `tobin` binaries"

  def install
    rm_f Dir["lib/*"]
    rm_f Dir["exe/*"]
    system "csh", "makeall.csh"
    mv "exe", "bin"
    pkgshare.install "doc", "data"
    prefix.install "bin", "include", "lib"

    lib.install_symlink "cspice.a" => "libcspice.a"
    lib.install_symlink "csupport.a" => "libcsupport.a"
  end
end
