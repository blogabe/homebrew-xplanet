class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "py2cairo"
  depends_on "blogabe/xplanet/pygobject"

  # Allow building with recent Pango, where some symbols were removed
  patch do
    url "https://raw.githubusercontent.com/blogabe/homebrew-xplanet/master/patches/pygtk-2.24.0-pango.diff"
    sha256 "af3f22f9aad9a37f67b8cd56d80b1a191d01bff039d5ff5ce9aa9f90ea232feb"
  end

  def install
    ENV.append "CFLAGS", "-ObjC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
