class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.2.tar.gz"
  sha256 "7d30578f5cf97b137a281f4548d131aafc0cde86bcfd10cc1e1bd72a81e65061"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "5d60799a5a3fe3f5b610669487587e5d341645cf4c245b8fe7522e8749dbf51c"
    sha256 cellar: :any,                 arm64_sonoma:  "d2391b33541e3f214238fd4da4fb98be3c55c065c851e9d17a61572505fe792e"
    sha256 cellar: :any,                 arm64_ventura: "f58bc25546277fb6993b81518243d50db1c8903d1e18c8d2b3919e0e8c0d4018"
    sha256 cellar: :any,                 sonoma:        "2f948ff9f4bca45282200bfd756bcea0e5cbe811962a255ef9ed61f39c54358a"
    sha256 cellar: :any,                 ventura:       "9a60e13d8c13559ef68a75add3000375ec0dddc160878b4546d5df873aa00804"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb4ac08a4b34cc4eda8cc2daff5378545447afb4c954e0c2929a4b34c93d580"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    # Work around for optimization bug causing corrupted last_tmp_file
    # Ref: https://github.com/Homebrew/homebrew-core/issues/207722
    # Ref: https://pari.math.u-bordeaux.fr/cgi-bin/bugreport.cgi?bug=2608
    ENV.O1 if ENV.compiler == :clang

    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps",
                          "--mt=pthread"

    # Explicitly set datadir to HOMEBREW_PREFIX/share/pari to allow for external packages to be found
    # We do this here rather than in configure because we still want the actual files to be installed to the Cellar
    objdir = Utils.safe_popen_read("./config/objdir").chomp
    inreplace %W[#{objdir}/pari.cfg #{objdir}/paricfg.h], pkgshare, "#{HOMEBREW_PREFIX}/share/pari"

    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", Superenv.shims_path, "/usr/bin"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"

    (testpath/"test.gp").write <<~GP
      default(parisize,"1G");
      default(realprecision,10);
      dist(a,b) = sqrt(a^2+b^2);
      print(dist(1,2));
    GP
    assert_equal "2.236067977\n", pipe_output("#{bin}/gp --quiet test.gp", "", 0)
  end
end
