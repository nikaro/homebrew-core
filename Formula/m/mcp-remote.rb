class McpRemote < Formula
  desc "Remote proxy for Model Context Protocol with OAuth support"
  homepage "https://github.com/geelen/mcp-remote"
  url "https://registry.npmjs.org/mcp-remote/-/mcp-remote-0.13.5.tgz"
  sha256 "a6f3ebdc118d197050197849b97f813e83cf398125a618fa92ff615c6803a85c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "303da661eb51a5f598bc825fb226128ff37ecce948155df1ff9725e550604250"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "Using transport strategy: http-first",
      shell_output("#{bin}/mcp-remote https://mcp.example.com/mcp 2>&1", 1)
  end
end
