class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  license "GPL-2.0-or-later"

  # I use revision to differentiate this formula on this tap from homebrew's core formula or another user's version
  # by using '99'.
  revision 99

  option "with-all", "Build with all default Xplanet configuration dependencies"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-pango", "Build Xplanet to support Internationalized text library"

  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "freetype"

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  # These are optional because they are not as widely used (cspice) or require a lot of deps inflating
  # time to compile, tools installed, ... (pango and netpbm).
  depends_on "cspice" => :optional
  depends_on "netpbm" => :optional
  depends_on "pango" => :optional

  # Backport r207: fix build with modern C++ compilers (C++11+)
  # https://sourceforge.net/p/xplanet/code/207/
  patch do
    url "https://raw.githubusercontent.com/archlinux/svntogit-community/040965e32860345ca2d744239b6e257da33460a2/trunk/xplanet-c%2B%2B11.patch"
    sha256 "e651c7081c43ea48090186580b5a2a5d5039ab3ffbf34f7dd970037a16081454"
  end

  # Backport r208: fix bug with -num_times flag
  # https://sourceforge.net/p/xplanet/code/208/
  patch :p2 do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/xplanet/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # Backport r214: fix compilation with giflib 5
  # https://sourceforge.net/p/xplanet/code/214/
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-r214-giflib5.patch"
    sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
  end

  # Backport r222: fix int-to-unsigned-char narrowing errors in readConfig.cpp
  # https://sourceforge.net/p/xplanet/code/222/
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-r222-narrowing.patch"
    sha256 "0f85f59870e2c2225ff79895fded895d2f73dd876ef02575e91fbbeb90be2722"
  end

  # Backport r223: fix string literal warnings in addSpiceObjects.cpp and DisplayBase.cpp
  # https://sourceforge.net/p/xplanet/code/223/
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-r223-string-literals.patch"
    sha256 "dc77013027a5faed71861b28aa4a910eb48116163a380d8735329f7c6101869a"
  end

  # Backport r224: add _Xconst define to ParseGeom.h
  # https://sourceforge.net/p/xplanet/code/224/
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-r224-xconst.patch"
    sha256 "d57eb756524a45b82a52602a3459e9b0a837f4b786911d873a570afab9e66fba"
  end

  # Backport r225: add trailing comma in keywords.h
  # https://sourceforge.net/p/xplanet/code/225/
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-r225-trailing-comma.patch"
    sha256 "666a9bf647815d92cf24b10c17d838a862bceea6a8052e2575fa2b288ae2b052"
  end

  def install
    # Update config.sub/config.guess to recognize modern macOS (darwin25+)
    %w[config.sub config.guess].each do |fn|
      am_dir = Formula["automake"].opt_share/"automake-#{Formula["automake"].version.major_minor}"
      cp am_dir/fn, fn
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-cygwin
      --with-aqua
      --without-x
      --without-xscreensaver
    ]

    # Recommended deps: enabled by default, pass --without if user opted out
    args << (build.with?("giflib") ? "--with-gif" : "--without-gif")
    args << (build.with?("jpeg") ? "--with-jpeg" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-libpng" : "--without-libpng")
    args << (build.with?("libtiff") ? "--with-libtiff" : "--without-libtiff")

    # Optional deps: disabled by default, pass --with if user opted in (or --with-all)
    if build.with?("cspice") || build.with?("all")
      args << "--with-cspice"
    else
      args << "--without-cspice"
    end

    if build.with?("pango") || build.with?("all")
      args << "--with-pango"
    else
      args << "--without-pango"
    end

    if build.with?("netpbm") || build.with?("all")
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append "CPPFLAGS", "-I#{netpbm}/include/netpbm"
      ENV.append "LDFLAGS", "-L#{netpbm}/lib"
      args << "--with-pnm"
    else
      args << "--without-pnm"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_predicate bin/"xplanet", :executable?
  end
end
