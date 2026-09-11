class Circleci < Formula
  desc "Official command-line tool for CircleCI"
  homepage "https://cli.circleci.com"
  # Updates should be pushed no more frequently than once per week.
  url "https://github.com/CircleCI-Public/circleci-cli.git",
      tag:      "v1.0.50034",
      revision: "004bba106ed1249b04747b9851f9c5619d4793fa"
  license "MIT"
  head "https://github.com/CircleCI-Public/circleci-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3d6b4e9787e8fac78cf7ab30c597275b8d539df6e0e20bda66500e6ae64e6275"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "221a11806df44ee7d8b655c5747f394414fb3072b82f0489b98e8a06daadf434"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d8e1664eb3814be16721e860ad20e3d9945d9d774365c5668afbdbbde6f65f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c3c6c0c69c977a7d8351ea27fdb3d5a3a7f205f28b329d2b4ed39ca8e95368fd"
    sha256 cellar: :any,                 x86_64_linux:      "678edb59dc45eaa5357115913855e5a4f6585f9f5b73260860ebebb5562322c6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/circleci"

    generate_completions_from_executable(bin/"circleci", "completion")
    system bin/"circleci", "man", "--output", man1/"circleci.1"
  end

  test do
    ENV["DO_NOT_TRACK"] = "1"
    # assert basic script execution
    assert_match(/^circleci #{version} \(\h{12}\)$/, shell_output("#{bin}/circleci version").strip)
    (testpath/".circleci.yml").write("{version: 2.1}")
    output = shell_output("#{bin}/circleci config pack #{testpath}/.circleci.yml")
    assert_match "version: 2.1", output
  end
end
