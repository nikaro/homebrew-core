class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://developers.cloudflare.com/workers/"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.131.1.tgz"
  sha256 "1b0863093d9caa36a8c5937ff35461a3ea13be32c3d1395ea909f363b7db0f19"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "24b72874df5e4472244bc19beb27add6992c5b502aaaad1a150ec5557a410d6e"
    sha256 cellar: :any, arm64_tahoe:       "24b72874df5e4472244bc19beb27add6992c5b502aaaad1a150ec5557a410d6e"
    sha256 cellar: :any, arm64_sequoia:     "24b72874df5e4472244bc19beb27add6992c5b502aaaad1a150ec5557a410d6e"
    sha256 cellar: :any, arm64_linux:       "c2d770586aab86dc3f7b4d7a667e29a661ea925bb001a4a4cc861f8f5568afcf"
    sha256 cellar: :any, x86_64_linux:      "a03fac9c3f3f23072583568def2ea1664064076d8e03ca1349f84758725cede2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]

    node_modules = libexec/"lib/node_modules/wrangler/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?

    generate_completions_from_executable(bin/"wrangler", "complete", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
