class OpenpgpCardSshAgent < Formula
  desc "Standalone SSH Agent for use with OpenPGP cards"
  homepage "https://codeberg.org/openpgp-card/ssh-agent/"
  url "https://codeberg.org/openpgp-card/ssh-agent/archive/v0.3.4.tar.gz"
  sha256 "b210f0d55e070b0e1024cc1d3a1317afb663929411b05443ec0ce79afd0c0a6a"
  license any_of: ["Apache-2.0", "MIT"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that the binary exists and can be executed
    assert_match "openpgp-card-ssh-agent", shell_output("#{bin}/openpgp-card-ssh-agent --help")

    # Test socket creation with timeout
    socket_path = "#{testpath}/ocsa.sock"
    pid = fork do
      exec "#{bin}/openpgp-card-ssh-agent", "-H", "unix://#{socket_path}"
    end
    sleep 1

    assert_path_exists socket_path
    Process.kill("TERM", pid)
  end
end
