class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-23.2.1.tgz"
  sha256 "9da5b6ea573fb377221e13ede170c8a2576bd0819791193a09a55d52c8cfd28d"
  license "MIT"
  version_scheme 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a1e01ec75374837be985d6dd6248f4d44711945c51ba111ea4fb844ce5faff72"
    sha256 cellar: :any,                 arm64_sequoia: "a1e01ec75374837be985d6dd6248f4d44711945c51ba111ea4fb844ce5faff72"
    sha256 cellar: :any,                 arm64_sonoma:  "a1e01ec75374837be985d6dd6248f4d44711945c51ba111ea4fb844ce5faff72"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a2524e766f4e7d3d65833cab13add01c8a1f17e19ebb06fefbdb8dff316a970a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "567163df6cad693ef53e36fed4320e25d39ee97e8b49f60ae76fc1c29b407ba9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # Avoid daemon and plugin worker sockets in the test sandbox.
    ENV["NX_DAEMON"] = "false"
    ENV["NX_ISOLATE_PLUGINS"] = "false"

    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx test").gsub(/\e\[[0-9;]*m/, "")
    assert_match "Successfully ran target test for project @acme/repo", output
  end
end
