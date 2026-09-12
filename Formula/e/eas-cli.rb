class EasCli < Formula
  desc "Command-line tool for working with Expo Application Services"
  homepage "https://docs.expo.dev/eas/"
  url "https://registry.npmjs.org/eas-cli/-/eas-cli-24.2.0.tgz"
  sha256 "fd434f2217fc5307f5972ed11879a00def8bc07594f44995d154cf3724451874"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56f8d41a6af3f466744177f5ea23d7aa8de63c9dfa806c46ae7bf04e3a2854eb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/eas --version")
    assert_match "Run this command inside a project directory",
                 shell_output("#{bin}/eas diagnostics 2>&1", 1)
  end
end
