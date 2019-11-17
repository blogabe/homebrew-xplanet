class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"

  # I use revision to differentiate this formula on this tap from homebrew's core formula or another user's version
  # by using '99'.  This is appended to either the stable or head versions and comes before any patch revision.
  # The patch revision is independent of the revision homebrew core formula uses.  It may or may not match.  Here,
  # the '.1' refer to the patch for the stable release; it's not needed for the head release, but cleaner to let it be.
  revision 99.1

  stable do
    url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
    sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"

    depends_on "pkg-config" => :build

    # Fix compilation with giflib 5
    # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
    patch do
      url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-giflib5.patch"
      sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
    end
  end

  # Xplanet has had many changes since the last formal release and keeping it up to date with patches
  # is clunky.  Adding HEAD download link to most current stable commit that compiles.
  head do
    dot = 214
    url "https://svn.code.sf.net/p/xplanet/code/trunk", :revision => dot
    version "1.3.1.#{dot}"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    if dot < 214
      patch do
        url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/xplanet-1.3.1-giflib5.patch"
        sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
      end
    end
  end

  option "with-x11", "Build for X11 instead of Aqua"
  option "with-all", "Build with default Xplanet configuration dependencies"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-pango", "Build Xplanet to support Internationalized text library"

  depends_on "freetype"

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  # These are optional because they are not as widely used (cspice) or require a lot of deps inflating
  # time to compile, tools installed, ... (pango and netpbm).
  if build.with?("all")
    depends_on "cspice"
    depends_on "netpbm"
    depends_on "pango"
  end

  depends_on "cspice" => :optional
  depends_on "netpbm" => :optional
  depends_on "pango" => :optional

  depends_on :x11 => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-cygwin
    ]

    if build.with?("x11")
      args << "--with-x" << "--with-xscreensaver" << "--without-aqua"
    else
      args << "--with-aqua" << "--without-x" << "--without-xscreensaver"
    end

    if build.without?("all")
      args << "--without-gif" if build.without?("giflib")
      args << "--without-jpeg" if build.without?("jpeg")
      args << "--without-libpng" if build.without?("libpng")
      args << "--without-libtiff" if build.without?("libtiff")
      args << "--without-pango" if build.without?("pango")
      args << "--without-pnm" if build.without?("netpbm")
      args << "--without-cspice" if build.without?("cspice")
    end

    if build.with?("netpbm") || build.with?("all")
      netpbm = Formula["netpbm"].opt_prefix
      ENV.append "CPPFLAGS", "-I#{netpbm}/include/netpbm"
      ENV.append "LDFLAGS", "-L#{netpbm}/lib"
    end

    system "./configure", *args
    system "make", "install"
  end
end
