class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://svn.code.sf.net/p/xplanet/code/trunk/", using: :svn, revision: "225"
  version "1.3.1.225"
  license "GPL-2.0-or-later"

  option "with-all", "Build with all default Xplanet configuration dependencies"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-pango", "Build Xplanet to support Internationalized text library"

  deprecated_option "without-jpeg" => "without-jpeg-turbo"

  depends_on "automake" => :build
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

  # Keep the temporary wallpaper available until Finder replies.
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/bfc88aab2d6d96c036e0eca5532f496091e0c431/patches/xplanet-1.3.1-aqua-reply.patch"
    sha256 "e648863fceb52938ad08f189e3a6a2157fa637faa98692844151353ef949d571"
  end

  def install
    # Keep the pkg-config prefix aligned with the existing FreeType consumers.
    inreplace "acinclude.m4", "PKG_CHECK_MODULES([FREETYPE2]", "PKG_CHECK_MODULES([FREETYPE]"
    inreplace "configure" do |s|
      s.gsub! "FREETYPE2_CFLAGS", "FREETYPE_CFLAGS"
      s.gsub! "FREETYPE2_LIBS", "FREETYPE_LIBS"
      s.gsub! "svn-r224", version.to_s
    end
    inreplace "configure.ac", "svn-r224", version.to_s

    # Generated files are patched above; do not regenerate with upstream Automake 1.16.
    touch "aclocal.m4"
    touch %w[configure config.h.in]
    touch Dir["**/Makefile.in"]

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
    assert_match "Xplanet #{version}", shell_output("#{bin}/xplanet -version")
  end
end
