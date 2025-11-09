class OpenpgpCardTools < Formula
  desc "CLI tool for inspecting, configuring and using OpenPGP card devices"
  homepage "https://codeberg.org/openpgp-card/openpgp-card-tools"
  url "https://codeberg.org/openpgp-card/openpgp-card-tools/archive/v0.11.10.tar.gz"
  sha256 "59ba6486878648e3bcaba6f1f62d02e23858faa821306eb395a8df105a0e39a1"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Generate shell completions
    mkdir "completions"
    ENV["OCT_COMPLETION_OUTPUT_DIR"] = "completions"
    system bin/"oct"

    # Install completions
    bash_completion.install "completions/oct.bash" => "oct"
    fish_completion.install "completions/oct.fish"
    zsh_completion.install "completions/_oct"
  end

  test do
    assert_match(/^oct #{version}/, shell_output("#{bin}/oct --version"))
  end
end
