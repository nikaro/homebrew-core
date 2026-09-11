class Rumdl < Formula
  desc "Markdown Linter and Formatter written in Rust"
  homepage "https://github.com/rvben/rumdl"
  url "https://github.com/rvben/rumdl/archive/refs/tags/v0.2.73.tar.gz"
  sha256 "69ffb6abe34d0667c38d4abc49abd41fbb7b0ba23890552a3e982840f9331faa"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "679fb0ce6bec2efad04edd03324257bb6422a5bad333be078991803b73098eb4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a036703a597c2f06b180b3a77f445287ccbb21497bad22b995bdac08bb2fb5a1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "59625f28d052ad22aad38789487e4f672b1dde7f8df255e56045600ff6fd4f40"
    sha256 cellar: :any,                 arm64_linux:       "4adce7a7c4682fd813c5579a3954ac986f07f8faec7226bcb3bf5086f8186743"
    sha256 cellar: :any,                 x86_64_linux:      "c8270289104b7197ca15d7893250fed64e37bfd979d6864e4c25e355d1b45e4a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"rumdl", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rumdl version")

    (testpath/"test-bad.md").write <<~MARKDOWN
      # Header 1
      body
    MARKDOWN
    (testpath/"test-good.md").write <<~MARKDOWN
      # Header 1

      body
    MARKDOWN

    assert_match "Success", shell_output("#{bin}/rumdl check test-good.md")
    assert_match "MD022", shell_output("#{bin}/rumdl check test-bad.md 2>&1", 1)
    assert_match "Fixed", shell_output("#{bin}/rumdl fmt test-bad.md")
    assert_equal (testpath/"test-good.md").read, (testpath/"test-bad.md").read
  end
end
