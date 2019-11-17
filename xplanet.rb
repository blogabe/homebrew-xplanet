class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"

  stable do
    url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
    sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"

    # Fix compilation with giflib 5
    # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
    patch do
      url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/xplanet-1.3.1-giflib5.patch"
      sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
    end
  end

  # Xplanet has had many changes since the last formal release and keeping it up to date with patches
  # is clunky.  Adding HEAD download link to most current stable commit that compiles.
  head do
    dot = 214
    url "https://svn.code.sf.net/p/xplanet/code/trunk", :revision => "#{dot}"
    version "1.3.1.#{dot}"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    if dot < 214
      patch do
        url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/xplanet-1.3.1-giflib5.patch"
        sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
      end
    end
  end

  # I prepend '99.' to differentiate my revisions, which are appended to the version number, from Xplanet
  # or any other user tap version of Xplanet. 
  # The actual revision number set here is independent of the revision the main core formula sets if at all.
  # Here, it refers to either the GifLib 5 patch from last stable release or the last compile-able commit.
  revision 99.1

  option "with-x11", "Build for X11 instead of Aqua"
  option "with-all", "Build with default Xplanet configuration dependencies"
  option "with-pango", "Build Xplanet to support Internationalized text library"
  option "with-netpbm", "Build Xplanet with PNM graphic support"
  option "with-cspice", "Build Xplanet with JPLs SPICE toolkit support"

  depends_on "pkg-config" => :build
  depends_on :x11 => :optional
  depends_on "freetype"

  depends_on "giflib" => :recommended
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended

  if build.with?("all")
    depends_on "pango"
    depends_on "netpbm"
    depends_on "cspice"
  end

  # These are optional because they are not as widely used (cspice) or require a lot of deps inflating
  # time to compile, tools installed, ... (pango and netpbm).
  depends_on "pango" => :optional
  depends_on "netpbm" => :optional
  depends_on "cspice" => :optional

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
    system "make"
    system "make", "install"
  end
end
