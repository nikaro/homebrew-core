class Dcd < Formula
  desc "Auto-complete program for the D programming language"
  homepage "https://github.com/dlang-community/DCD"
  url "https://github.com/dlang-community/DCD.git",
      tag:      "v0.18.5",
      revision: "d2e572f1dbb000004cb0b8dd8b851e3e8af84c77"
  license "GPL-3.0-or-later"
  head "https://github.com/dlang-community/dcd.git", branch: "master"

  bottle do
    sha256               arm64_golden_gate: "620c8f5c0d0bc2b36e984e2e5803952388324047baba4820bf650151d4d470c7"
    sha256               arm64_tahoe:       "9480366e3378e58118a9cca43ec88cd820e0b1283452c34268fb6eacff50365a"
    sha256               arm64_sequoia:     "52857b698e01820ec9b1287f53e7cc115f8de73b3f4153d8c4071c94fd8feeda"
    sha256 cellar: :any, arm64_linux:       "9953a5eba2e3342ed5c494b733c4414d83d685405bbb541e31eaacee21f7812b"
    sha256 cellar: :any, x86_64_linux:      "0df81b8dfffd0c52b1b9a8f0da177f7b28711680347be568e1b993647e13256a"
  end

  depends_on "ldc" => :build

  def install
    system "make", "ldc"
    bin.install "bin/dcd-client", "bin/dcd-server"
  end

  test do
    port = free_port

    # spawn a server, using a non-default port to avoid
    # clashes with pre-existing dcd-server instances
    server = spawn bin/"dcd-server", "-p", port.to_s
    # Give it generous time to load
    sleep 0.5
    # query the server from a client
    system bin/"dcd-client", "-q", "-p", port.to_s
  ensure
    Process.kill "TERM", server
    Process.wait server
  end
end
