class DejaVu < Formula
  desc "Local searchable memory over the session histories of coding agents"
  homepage "https://github.com/vshulcz/deja-vu"
  url "https://github.com/vshulcz/deja-vu/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "1151d2fd8b14621cb4a5d594bd51e92eae65091bbf6955541cc6f88e7c7f29ff"
  license "MIT"
  head "https://github.com/vshulcz/deja-vu.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c45b7e0619c644bfbd60576da258091f0a0c4cc507d2ed60812038c50ccb2a0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c45b7e0619c644bfbd60576da258091f0a0c4cc507d2ed60812038c50ccb2a0a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c45b7e0619c644bfbd60576da258091f0a0c4cc507d2ed60812038c50ccb2a0a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f08509a435acdab0ed7ccec7f7d124824e211ec3dbc684f7ea0aee93a09beda7"
    sha256 cellar: :any,                 x86_64_linux:  "ded44f3d77adc75d07efcf8c23204aeddbbb91ee88267d34e28ffe35c9fc4509"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"deja"), "./cmd/deja"

    generate_completions_from_executable(bin/"deja", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deja version")
    assert_match '"schema_version": 2', shell_output("#{bin}/deja doctor --json --offline")
    assert_match "no matches", shell_output("#{bin}/deja search nothing-is-indexed-here 2>&1")
  end
end
