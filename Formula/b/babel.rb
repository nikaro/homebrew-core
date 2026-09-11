class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-8.0.5.tgz"
  sha256 "210ed579cf6d37c0ac93df78c6fd52fee67f392485a92ac7b42ff38cc3030751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "89b1cd8b64831b698c90fea4ca2c42d3bf54b3da528f1be38e353f1b9f38ea29"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"script.js").write <<~JS
      [1,2,3].map(n => n + 1);
    JS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_path_exists testpath/"script-compiled.js", "script-compiled.js was not generated"
  end
end
