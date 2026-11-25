class Xplanet < Formula
  desc "Create HQ wallpapers of planet Earth"
  homepage "https://xplanet.sourceforge.io/"
  url "https://github.com/blogabe/homebrew-xplanet/releases/download/xplanet-1.3.1.225/xplanet-1.3.1.225.tar.gz"
  sha256 "e7ee5854542055b0dda8afb8fabdafd3978c7ac6f7cdd04ae47592431f3b3e24"
  version "1.3.1.225"
  license "GPL-2.0-or-later"
  revision 2

  # Preserve the pinned source archive and apply the renderer-only Alpha-5 patch.
  patch :DATA

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
    # The archive already includes FreeType, Aqua and platform-helper fixes.
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

__END__
diff --git a/src/Options.cpp b/src/Options.cpp
--- a/src/Options.cpp
+++ b/src/Options.cpp
@@ -925,6 +925,7 @@
             break;
         case VERSIONNUMBER:
             printVersion();
+            cout << "TLE catalog IDs: Alpha-5" << endl;
             exit(EXIT_SUCCESS);
             break;
         case VROOT:
diff --git a/src/libsgp4sdp4/sgp_in.c b/src/libsgp4sdp4/sgp_in.c
--- a/src/libsgp4sdp4/sgp_in.c
+++ b/src/libsgp4sdp4/sgp_in.c
@@ -38,6 +38,29 @@
 
 /*------------------------------------------------------------------*/
 
+/* Space-Track Alpha-5 extends the five-column field without changing
+   any of the orbital data. I and O are not part of the alphabet. */
+static int
+Catalog_Number(const char *field)
+{
+  static const char prefix[] = "ABCDEFGHJKLMNPQRSTUVWXYZ";
+  int i = 0, number = 0;
+  const char *letter = strchr(prefix, field[0]);
+  if (letter != NULL && *letter != '\0')
+    {
+      number = (int)(letter - prefix) + 10;
+      i = 1;
+    }
+  else
+    while (i < 4 && field[i] == ' ') i++;
+  for (; i < 5; i++)
+    {
+      if (field[i] < '0' || field[i] > '9') return 0;
+      number = 10 * number + (field[i] - '0');
+    }
+  return number;
+}
+
 /* Carries out various checks on a TLE set to verify its validity */
 /* tle_set is a character string holding the two lines read    */
 /* from a text file containing NASA format Keplerian elements. */
@@ -51,7 +74,8 @@
   if( (tle_set[0] != '1') || (tle_set[69] != '2') )
     return (0);
   /* Verify that Satellite Number is same in both lines */
-  if( strncmp( &tle_set[2], &tle_set[71], 5 ) != 0 )
+  if( Catalog_Number(&tle_set[2]) == 0
+      || strncmp( &tle_set[2], &tle_set[71], 5 ) != 0 )
     return (0);
   /* Check that various elements are in the right place */
   if( 
@@ -82,9 +106,7 @@
 
   /** Decode Card 1 **/
   /* Satellite's catalogue number */
-  strncpy( buff, &tle_set[2],5 );
-  buff[5] = '\0';
-  tle->catnr = atoi(buff);
+  tle->catnr = Catalog_Number(&tle_set[2]);
 
   /* International Designator for satellite */
   strncpy( tle->idesg, &tle_set[9],8 );
