class Uv < Formula
  desc "Extremely fast Python package installer and resolver, written in Rust"
  homepage "https://github.com/astral-sh/uv"
  url "https://github.com/astral-sh/uv/archive/refs/tags/0.5.21.tar.gz"
  sha256 "a7de0acb9fcdb4dce09d2d16397c91b30cbf653ceeacc30b250df42c9154edbe"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/astral-sh/uv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59af07ec55cca270a5fec56a7ec009c2442b57dee45344eaabf1c25a80192c83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6cd04c380317406e3edb89aba9845691e980c557d70cbab5225bac3d9b966c40"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb593fea413cabd1e3f9f0fdb7784048d77a24bea604ae4019dca1bb2622ee5"
    sha256 cellar: :any_skip_relocation, sonoma:        "2888802a8c214a6f81ff4fc50f7127bad62974e3d34dbb339db1abd5ebaf315c"
    sha256 cellar: :any_skip_relocation, ventura:       "d403bd4c6af8385f15b29f0234b29245fdadcd3f89fcecf1134bcf1b3327aaf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44902326106870b73afaaecbcfaf80d988e480559dafb262a8d7b5ac839df86d"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "python" => :test
  uses_from_macos "bzip2"
  uses_from_macos "xz"

  def install
    ENV["UV_COMMIT_HASH"] = ENV["UV_COMMIT_SHORT_HASH"] = tap.user
    ENV["UV_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "crates/uv")
    generate_completions_from_executable(bin/"uv", "generate-shell-completion")
    generate_completions_from_executable(bin/"uvx", "--generate-shell-completion")
  end

  test do
    (testpath/"requirements.in").write <<~REQUIREMENTS
      requests
    REQUIREMENTS

    compiled = shell_output("#{bin}/uv pip compile -q requirements.in")
    assert_match "This file was autogenerated by uv", compiled
    assert_match "# via requests", compiled

    assert_match "ruff 0.5.1", shell_output("#{bin}/uvx -q ruff@0.5.1 --version")
  end
end
