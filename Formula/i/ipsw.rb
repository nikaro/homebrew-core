class Ipsw < Formula
  desc "Research tool for iOS & macOS devices"
  homepage "https://blacktop.github.io/ipsw"
  url "https://github.com/blacktop/ipsw/archive/refs/tags/v3.1.716.tar.gz"
  sha256 "ad6d128e439255ab586ba40c60dfeb257f880e0bd2b5089f3ce903cafc9f1b2c"
  license "MIT"
  head "https://github.com/blacktop/ipsw.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "52dd429ad1f00553c95d867a6cf5da260309da3d80e9a8eca44ed0bf16049eb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b72eb64eac58a581f3fef079f2c98cf8b330a88b02e9deadc737dfe201ba82f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d24eb910f7d3eca9df55b2d1c334bf213cc0ffc8b6b05ba972dfe0b775b8494"
    sha256 cellar: :any,                 arm64_linux:   "c09fe31d5b171265d5bd4e62455680855b88794b128533fe9951c30dfff1fb99"
    sha256 cellar: :any,                 x86_64_linux:  "aa9703b333fa698491672c5cb3162bc3a43047bf504d92470d32ec203de998c5"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppVersion=#{version}
      -X github.com/blacktop/ipsw/cmd/ipsw/cmd.AppBuildCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/ipsw"
    generate_completions_from_executable(bin/"ipsw", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ipsw version")

    assert_match "iPad Pro (12.9-inch) (6th gen)", shell_output("#{bin}/ipsw device-list")
  end
end
