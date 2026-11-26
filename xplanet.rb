class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://github.com/blogabe/homebrew-xplanet/releases/download/xplanet-1.3.1.225-source.2/xplanet-1.3.1.225-source.2.tar.gz"
  sha256 "f4211953d92f450e70e26516b82e7b4e199e0fbce10b020baa356bc1e0e9014c"
  version "1.3.1.225"
  license "GPL-2.0-or-later"
  revision 3

  option "with-all", "Build with all default Xplanet configuration dependencies"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-pango", "Build Xplanet to support Internationalized text library"

  deprecated_option "without-jpeg" => "without-jpeg-turbo"

  depends_on "pkgconf" => :build
  depends_on "freetype"

  depends_on "giflib" => :recommended
  depends_on "jpeg-turbo" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  # These are optional because they are not as widely used (cspice) or require a lot of deps inflating
  # time to compile, tools installed, ... (pango and netpbm).
  if build.with?("all")
    depends_on "cspice"
    depends_on "netpbm"
    depends_on "pango"
  else
    depends_on "cspice" => :optional
    depends_on "netpbm" => :optional
    depends_on "pango" => :optional
  end

  def install
    # The archive includes the renderer fixes; no tap patch is needed.
    system "./prepare-build.sh"

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
    args << (build.with?("jpeg-turbo") ? "--with-jpeg" : "--without-jpeg")
    args << (build.with?("libpng") ? "--with-png" : "--without-png")
    args << (build.with?("libtiff") ? "--with-tiff" : "--without-tiff")

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
    output = shell_output("#{bin}/xplanet -version")
    assert_match "Xplanet #{version}", output
    assert_match "TLE catalog IDs: Alpha-5", output
  end
end
