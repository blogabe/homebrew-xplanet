class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/xplanet/xplanet/1.3.1/xplanet-1.3.1.tar.gz"
  sha256 "4380d570a8bf27b81fb629c97a636c1673407f4ac4989ce931720078a90aece7"
  # I prepend '99.' to differentiate from Xplanet or any other user tap version of Xplanet.
  # in this case, Xplanet revision is set to 2, but I have this set to 3 because this version includes the leap second fix.
  revision 99.3

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

  depends_on "pango" => :optional
  depends_on "netpbm" => :optional
  depends_on "cspice" => :optional

  # patches bug in 1.3.1 with flag -num_times=2 (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/208/tree/trunk/src/libdisplay/DisplayOutput.cpp?diff=5056482efd48f8457fc7910a:207
  patch :p2 do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/xplanet-1.3.1-ntimes.patch"
    sha256 "3f95ba8d5886703afffdd61ac2a0cd147f8d659650e291979f26130d81b18433"
  end

  # patches bug in 1.3.1 related to 2017 leap second (1.3.2 will contain fix, when released)
  # https://sourceforge.net/p/xplanet/code/209/tree//trunk/src/xpUtil.cpp?diff=205
  patch :p2 do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/xplanet-1.3.1-2017leapsecond.patch"
    sha256 "bd0dbb4ebc4f92b75d29ae1c58d1b1f1f6507c436fef41528d41e71f01733aaa"
  end

  # Fix compilation with giflib 5
  # https://xplanet.sourceforge.io/FUDforum2/index.php?t=msg&th=592
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/xplanet-1.3.1-giflib5.patch"
    sha256 "6bde76973bc9e931756d260ac838b3726d1dad8f2f795b6ffa23849005d382d7"
  end

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
