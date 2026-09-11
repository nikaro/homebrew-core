class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.121.0.tgz"
  sha256 "2f239663bedb363de0fa9947c646e3cbb1c54b089ab5d5a605f133da35519415"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "dc31eb6a883d7fde1aceaaf46b5cb1064ca52dfc55921958b2b4002c7b78f283"
    sha256 cellar: :any,                 arm64_sequoia: "dc31eb6a883d7fde1aceaaf46b5cb1064ca52dfc55921958b2b4002c7b78f283"
    sha256 cellar: :any,                 arm64_sonoma:  "dc31eb6a883d7fde1aceaaf46b5cb1064ca52dfc55921958b2b4002c7b78f283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c53291274267c73d92844ad1142888a9cec3b94783bff76cdc0ee5cb8b703b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b54dc08bebc257f074bc0434493f54cf2b0053e01cd3d3608b01178e7ff5508"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
