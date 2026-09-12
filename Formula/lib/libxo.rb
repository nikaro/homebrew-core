class Libxo < Formula
  desc "Allows an application to generate text, XML, JSON, and HTML output"
  homepage "https://juniper.github.io/libxo/libxo-manual.html"
  url "https://github.com/Juniper/libxo/releases/download/2.1.0/libxo-2.1.0.tar.gz"
  sha256 "5b4208199e5a785a3b5d7ee07e31788f037cf9acd6951f959d252c1e1b93c50c"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "953e91c12c927736357428136d2403b1e2d610e1d3e8fd557fd7878759d18aa4"
    sha256 arm64_sequoia: "c8250f122d0d6741448070f5c0eccd4beecf5a6b1315a4acc1bceb6be3f92588"
    sha256 arm64_sonoma:  "be39da316cca8f97ef0c4c226dd6b4c56a03393bd3ba1b33c1d92d71846d89ba"
    sha256 sonoma:        "764b52990cd9477f2e6c0e6665270a2d6b2528b8b5ce5053f9d734e1f23eb4c3"
    sha256 arm64_linux:   "ee547be31bd6316d94d32176ee7c6d0ab7664f628c328338f3282e5e8a631986"
    sha256 x86_64_linux:  "39d3eea6c0f848ddf09757a8a79113bd8d1b116315208018899b4d15f212f06f"
  end

  depends_on "byacc" => :build # the XPath parser needs byacc, not bison
  depends_on "libtool" => :build
  depends_on "gettext"

  # Only include `bsd/string.h` in the gettext test when configure found it
  patch do
    url "https://github.com/Juniper/libxo/commit/dc0017cb7cea89363a27721f6ab4593305167b61.patch?full_index=1"
    sha256 "37f0bf7e9e01a94f185dbd59af3785688eaf4267bf4b8a76d92b1cbe6cfc5413"
    type :unofficial
    resolves "https://github.com/Juniper/libxo/pull/119"
  end

  def install
    # Nothing uses libcrypto, but finding it adds -lcrypto to every link
    ENV["ac_cv_lib_crypto_MD5_Init"] = "no"

    # configure only looks for gettext in /usr, /opt/local and /usr/local
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-gettext=#{formula_opt_prefix("gettext")}",
                          "--prefix=#{prefix}"

    # glibc 2.38+ has `strlcpy` but does not declare it, so libxo leaves it
    # undefined in `libxo.so`; resolve it at load time (keeping the `-ldl` the
    # Makefile sets). Not needed on macOS, where `strlcpy` is in libc.
    if OS.linux?
      system "make", "install", "LDFLAGS=-ldl -Wl,--allow-shlib-undefined"
    else
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libxo/xo.h>
      int main() {
        xo_set_flags(NULL, XOF_KEYS);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxo", "-o", "test"
    system "./test"
  end
end
