class Xplanetfx < Formula
  desc "Configure, run or daemonize xplanet for HQ Earth wallpapers"
  homepage "http://mein-neues-blog.de/xplanetFX/"
  url "http://repository.mein-neues-blog.de:9000/archive/xplanetfx-2.6.14_all.tar.gz"
  version "2.6.14"
  sha256 "1d4a451ff30cbe520adde4ee4f70b943c020950d97acc643d25ee7339cc2b250"

  option "without-gui", "Build to run xplanetFX from the command-line only"
  option "without-gnu-sed", "Build to use GNU sed instead of macOS sed"
  option "with-xp-all", "Build to use xplanet with all default options"
  option "with-complete", "Build to use xplanet with all default options and GNU sed instead of macOS sed"

  xpHomebrew=0
  xpblogabe=0
  if !File.exists?("#{HOMEBREW_PREFIX}/Cellar/xplanet")
    # Xplanet is not installed.  Use this tap's version.
    xpblogabe=1
  else
    # Xplanet is already installed.  Determine which version and do some error checking.
     Dir.foreach("#{HOMEBREW_PREFIX}/Cellar/xplanet") do |xpVersion|
      next if xpVersion == '.' or xpVersion == '..'
      if xpVersion.include? "_99."
        xpblogabe=1
      else
        xpHomebrew=1
      end
    end
  end

  if (xpHomebrew==1)
    if (xpblogabe==1)
      puts "There appear to be more than one version of Xplanet installed.  `brew uninstall` the redundant versions and retry xplanetFX installation."
      goto done;
    else
      # Homebrew Xplanet is already installed.  Keep on using this version, but alert user.
      puts "Looks like you're already using Homebrew's Xplanet formula.  This should not be a problem, but you may want to consider using this tap's version of Xplanet."
      depends_on "xplanet"
    end
  else
    # Use this tap's version of Xplanet.
    if build.with?("xp-all") || build.with?("complete")
      depends_on "blogabe/xplanet/xplanet" => %W[ with-pango --with-netpbm --with-cspice ]
    else
      depends_on "blogabe/xplanet/xplanet"
    end
  end

  depends_on "imagemagick"
  depends_on "wget"
  depends_on "coreutils"
  depends_on "gnu-sed" if build.with?("gnu-sed") || build.with?("complete")

  if build.with?("gui")
    depends_on "librsvg"
    depends_on "pygtk" => "with-libglade"
  end

  skip_clean "share/xplanetFX"

  def install
    inreplace "bin/xplanetFX", "WORKDIR=/usr/share/xplanetFX", "WORKDIR=#{HOMEBREW_PREFIX}/share/xplanetFX"

    prefix.install "bin", "share"

    path = "#{Formula["coreutils"].opt_libexec}/gnubin"
    path += ":#{Formula["gnu-sed"].opt_libexec}/gnubin" if build.with?("gnu-sed") || build.with?("complete")
    if build.with?("gui")
      ENV.prepend_create_path "PYTHONPATH", "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/gtk-2.0"
      ENV.prepend_create_path "GDK_PIXBUF_MODULEDIR", "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
    bin.env_script_all_files(libexec+"bin", :PATH => "#{path}:$PATH", :PYTHONPATH => ENV["PYTHONPATH"], :GDK_PIXBUF_MODULEDIR => ENV["GDK_PIXBUF_MODULEDIR"])

    done:
    .end
  end

  def post_install
    if build.with?("gui")
      # Change the version directory below with any future update
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
      system "#{HOMEBREW_PREFIX}/bin/gdk-pixbuf-query-loaders", "--update-cache"
    end
  end
end
