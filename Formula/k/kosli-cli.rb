class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "326bbcd0954b5e6cffacf5ab7251d0fac85ff2a4c6f3c9bf2e0c20e6d0b3fb07"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "64dc31691e5a9a34f293ffebfe304d0b1c355a9bd6dd6552ba7b85f137bb0b0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "625fcbaa0c6ebc293febe09d4edb74dd0fbd2cc7ef27b5a0ec109bb7eff5082e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf3a926b64e68b39522164f03310e7f4936699d6b45b887bc6d7490ad342b84c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "678f9079f07807a98e686e3fe01f5f8ac0d02872c66726ecfc179b8c160a5cfa"
    sha256 cellar: :any,                 x86_64_linux:      "e17533aaf937e4cb66e03c2c8507ba91cae8fe4c09fdb0cb89ac934ae42af948"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
