class Rulesync < Formula
  desc "Unified AI rules management CLI tool"
  homepage "https://github.com/dyoshikawa/rulesync"
  url "https://registry.npmjs.org/rulesync/-/rulesync-16.27.0.tgz"
  sha256 "02515eb11f4f6680019b22bf43ff27361fc56c621e5b8e48c6ee0ac3d4c4e4f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd9e0ba1745e6a109232fad91a3aac8a9b305fc349635b98531950219ec066a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd9e0ba1745e6a109232fad91a3aac8a9b305fc349635b98531950219ec066a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd9e0ba1745e6a109232fad91a3aac8a9b305fc349635b98531950219ec066a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85d65c0ad13b7a8f166609c87d9e10a5455c88fae2349cab64589bfd62ff040e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85d65c0ad13b7a8f166609c87d9e10a5455c88fae2349cab64589bfd62ff040e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rulesync --version")

    output = shell_output("#{bin}/rulesync init")
    assert_match "rulesync initialized successfully", output
    assert_match "Project overview and general development guidelines", (testpath/".rulesync/rules/overview.md").read
  end
end
