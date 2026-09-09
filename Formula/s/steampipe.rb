class Steampipe < Formula
  desc "Use SQL to instantly query your cloud services"
  homepage "https://steampipe.io/"
  url "https://github.com/turbot/steampipe/archive/refs/tags/v2.4.6.tar.gz"
  sha256 "fa685e46d435a9eb59d3e69bf718bf19bfeac17764c616fa93fd9ce5c5d9cd80"
  license "AGPL-3.0-only"
  head "https://github.com/turbot/steampipe.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74a6c85762486e7ec3f898883f9d51112a0c9b0a7267a6de6540e245c887e0c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c5e4b0f5ac600d37c3f4d001e0c10c05ae9d8ffdc445d72cf3dcc5caa281043"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49a56d1f8864c1fb904325c7e4e15cf1b456b458c15edec0a37b472340ccb9c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb6b92f0504e3b70cc2c8cdbdb51fd523f80ef710d3b3819769cc2ee8bba05f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ceba844b2ecdbefa8ca589e3eba763f1bb455adfe8c07ef3d7c6dd7fe9c117a"
    sha256 cellar: :any,                 x86_64_linux:  "c6e2493c0daad1635013673008831439d041317461d97fe95efc5e1c49b6246f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:, tags: "http2legacy")

    generate_completions_from_executable(bin/"steampipe", shell_parameter_format: :cobra)
  end

  test do
    ENV["STEAMPIPE_INSTALL_DIR"] = testpath

    output = shell_output("#{bin}/steampipe service status")
    assert_match "Steampipe service is not installed", output

    assert_match version.to_s, shell_output("#{bin}/steampipe --version")
  end
end
