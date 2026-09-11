class Ovsx < Formula
  desc "Command-line interface for Eclipse Open VSX"
  homepage "https://www.npmjs.com/package/ovsx"
  url "https://registry.npmjs.org/ovsx/-/ovsx-1.2.0.tgz"
  sha256 "c161a2730cd74021e087b7012e54070c438531abe51b2b2739390edefca9c59e"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6238633f47ebc022fec061b1e3de1cf4cad48180804cba241ba6acc0c9664dd7"
    sha256 cellar: :any, arm64_sequoia: "6238633f47ebc022fec061b1e3de1cf4cad48180804cba241ba6acc0c9664dd7"
    sha256 cellar: :any, arm64_sonoma:  "6238633f47ebc022fec061b1e3de1cf4cad48180804cba241ba6acc0c9664dd7"
    sha256 cellar: :any, sonoma:        "a236b31d41994685f933f7363f78514230ad50eb32f247e8a21fc6d1202863a5"
    sha256 cellar: :any, arm64_linux:   "758cc0389b19b8a74a85ce3bbe2a6e211442fd401fb3dbd913e83e5b31feb93c"
    sha256 cellar: :any, x86_64_linux:  "7a7093a9a309132aa7c9f775f8244c446f7879837dad5652adfd9fae92bfcf54"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    error = shell_output("#{bin}/ovsx verify-pat 2>&1", 1)
    assert_match "Unable to read the namespace's name", error
  end
end
