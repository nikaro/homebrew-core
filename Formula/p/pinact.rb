class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https://github.com/suzuki-shunsuke/pinact"
  url "https://github.com/suzuki-shunsuke/pinact/archive/refs/tags/v5.0.0.tar.gz"
  sha256 "fe9a37ca6f3e264697ba3b93ae412f88c9112e41ef56a46e2d2b25b705c7a8e0"
  license "MIT"
  head "https://github.com/suzuki-shunsuke/pinact.git", branch: "main"

  # Pre-release version has a suffix `-\d` for example `3.0.0-0`
  # so we restrict the regex to only match stable versions
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "03f49dc6a8584f42d0448cf0829e5e94b6cd987144aca22aedf2e0e7d9d1fd82"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed29f6b7deee2751894f26251c135d041c514acb82ec81c3f96e470ffde81cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed29f6b7deee2751894f26251c135d041c514acb82ec81c3f96e470ffde81cd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "ed29f6b7deee2751894f26251c135d041c514acb82ec81c3f96e470ffde81cd0"
    sha256 cellar: :any_skip_relocation, sonoma:            "135d05fd0317ee449a4e8ca9321b261b60178da5da7c6a8fd8a7c964e055384a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "60b1ec0ea7fc14c3f6715a2e9c7964ba101ac2b778e03dd2cd3823b7ef31aae2"
    sha256 cellar: :any,                 x86_64_linux:      "3215e646539080eb1053bacdb3519fabe1169ff0a54de621b8136676ab5de18f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pinact --version")

    (testpath/"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actions/checkout@v3
            - run: npm install && npm test
    YAML

    system bin/"pinact", "run", "action.yml"

    assert_match(%r{.*?actions/checkout@[a-f0-9]{40}}, (testpath/"action.yml").read)
  end
end
