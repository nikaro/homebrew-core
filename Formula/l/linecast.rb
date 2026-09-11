class Linecast < Formula
  include Language::Python::Virtualenv

  desc "Weather, tides, the sun, the moon, and maps, drawn for the terminal"
  homepage "https://github.com/ashuttl/linecast"
  url "https://files.pythonhosted.org/packages/fd/f4/b3752931409dfb642f7b87e1ff9f04a5b5059455f2d95f30ea34c2664f4d/linecast-2.4.0.tar.gz"
  sha256 "4c7e1e94d322b7ad7b62cb03ae2571568c0735481cdcf2463babee00fe42613c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e82ac3ed794ffc3a7986f67d5a7808a9892754fd152b6425c6531df33d2bc2f7"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/linecast --version")

    output = shell_output("#{bin}/linecast sunshine --location 43.657,-70.258 --json")
    assert_match '"schema": 1', output
    assert_match '"sunrise":', output
    assert_match '"sunset":', output
  end
end
