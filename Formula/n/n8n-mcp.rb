class N8nMcp < Formula
  desc "MCP for Claude Desktop, Claude Code, Windsurf, Cursor to build n8n workflows"
  homepage "https://www.n8n-mcp.com/"
  url "https://registry.npmjs.org/n8n-mcp/-/n8n-mcp-2.84.1.tgz"
  sha256 "c28882eaaf0f0feb59952a3efc94425226482a8e2a83cfa1a96913c0edd25125"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d414f9f22f01ead4e522e8f65b4cd5f48f328b8839631133bd94add3e2a637e6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = [
      %Q({"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"homebrew","version":"#{version}"}}}),
      '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}',
      '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}',
    ].join("\n") + "\n"

    output = pipe_output(bin/"n8n-mcp", json, 0)
    assert_match "\"name\":\"n8n-documentation-mcp\"", output
    assert_match "\"name\":\"search_nodes\"", output
  end
end
