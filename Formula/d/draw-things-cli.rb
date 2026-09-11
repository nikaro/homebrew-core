class DrawThingsCli < Formula
  desc "Local inference and LoRA training CLI for Draw Things"
  homepage "https://github.com/drawthingsai/draw-things-community"
  url "https://github.com/drawthingsai/draw-things-community/archive/refs/tags/v26.0910.1.tar.gz"
  sha256 "c5c91c0641b1efd12079e8151751e0a1b299d6374b4fa803abea80e695787eee"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dfa13c36ec1cc599a6b21ec2b655f44d3c7416a687f07e62caabbe26daba95b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ca7974bb402d9d8fae361a61619d792add641017bd062f578888f8af3efeba"
  end

  depends_on xcode: ["26.3", :build]
  depends_on macos: :sequoia # aligned to build Xcode as cannot cross-compile

  uses_from_macos "swift" => :build

  def install
    system "swift", "build", "--product", "draw-things-cli", *std_swift_args
    bin.install ".build/release/draw-things-cli"

    generate_completions_from_executable(bin/"draw-things-cli", "completion")
  end

  test do
    # Point --models-dir into testpath: the default location is outside the
    # test sandbox and depends on host state (Draw Things app container)
    models_dir = testpath/"Models"

    list = shell_output("#{bin}/draw-things-cli models list --downloaded-only --offline --models-dir #{models_dir}")
    assert_match "No models found.", list

    generate = shell_output(
      "#{bin}/draw-things-cli generate --models-dir #{models_dir} --model test --output . --prompt 'test' 2>&1", 64
    )
    assert_match "Error: Could not resolve --model 'test'.", generate
  end
end
