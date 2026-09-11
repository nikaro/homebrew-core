class Pixivbiu < Formula
  desc "Pixiv client. Easy to search, browse, and download artworks"
  homepage "https://github.com/txperl/PixivBiu"
  url "https://github.com/txperl/PixivBiu/archive/refs/tags/v3.1.2.tar.gz"
  sha256 "3993bcb65abac9a0138adbc698faabd402fce84fbee0994307785cb2995e5827"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b7c71aa6569256e0b5a870c53c9f45ebb3b3fcff570a0349694af63bb0c8431"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f0e5be1f4e2de9901e9282b8bf37980a8161f339994534600e372d932a4d72f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90f2f979f6efe3258255fc6a7a4dd8edf5a6a7c94dfc3b37239d9e3dddf04a36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "29ff3dc8a3274d9a3c4ecd48078cf4c47d5982cd638955871e0840032ba1e262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d0040235a94f28b7abe6de436897fd399731bff807ef13b24ca696f2ca1cb04d"
  end

  depends_on "bun" => :build
  depends_on "go" => :build

  def install
    system "make", "dist", "VERSION=#{version}"
    bin.install "bin/pixivbiu"
  end

  test do
    port = free_port
    data_dir = testpath/"data"
    data_dir.mkdir
    ENV["PIXIVBIU_DATA_DIR"] = data_dir
    ENV["PIXIVBIU_SERVER_PORT"] = port.to_s

    pid = spawn bin/"pixivbiu", "open=false"
    assert_match '"status":"ok"', shell_output("curl -fsS --retry 10 --retry-connrefused --retry-delay 1 'http://127.0.0.1:#{port}/api/v1/health'")
  ensure
    Process.kill "SIGINT", pid
    Process.wait pid
  end
end
