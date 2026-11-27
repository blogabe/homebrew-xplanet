class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://github.com/blogabe/xplanet-src/releases/download/v1.6.0/xplanet-1.6.0.tar.gz"
  sha256 "10a114f39ecae278f1066d475c70bdb91817cc5241cf24641fc2d892809392e7"
  version "1.6.0"
  license "GPL-2.0-or-later"

  option "with-all", "Build with all default Xplanet configuration dependencies"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-pango", "Build Xplanet to support Internationalized text library"

  deprecated_option "without-jpeg" => "without-jpeg-turbo"

  depends_on macos: :ventura
  depends_on "pkgconf" => :build
  depends_on "freetype"

  depends_on "giflib" => :recommended
  depends_on "jpeg-turbo" => :recommended
  depends_on "libpng"
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
      --enable-desktop-layer
      --with-png
      --without-x
      --without-xscreensaver
    ]

    # Recommended deps: enabled by default, pass --without if user opted out
    args << (build.with?("giflib") ? "--with-gif" : "--without-gif")
    args << (build.with?("jpeg-turbo") ? "--with-jpeg" : "--without-jpeg")
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
    assert_includes output.lines.map(&:chomp), "Frame pipe: 1"
    assert_predicate bin/"xplanet-desktop", :executable?
    assert_match "Usage: xplanet-desktop", shell_output("#{bin}/xplanet-desktop --help")
    if output.lines.map(&:strip).include?("JPEG")
      frame_hash = shell_output("#{bin}/xplanet-desktop --check-frame 160x80 " \
                                "#{bin}/xplanet #{testpath} 1 10 1 -- " \
                                "-target earth -projection rectangular -date 20261125.120000")
      assert_match(/\A[0-9a-f]{64}\n\z/, frame_hash)
    end
  end
end
