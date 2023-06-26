require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.142.0.tgz"
  sha256 "759e62521473bee99f6f84294a914693154ce039e390f954467af19b2efee934"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_ventura:  "e68f15bb93035a9cc1190eb4d8f8d6dbe3d807b667cb237f8abe946c25ed9b82"
    sha256                               arm64_monterey: "a1e17c9d5f722c67c64908983c4fa8be63bdd0ad8d3781c6c44dbea8a87bccdd"
    sha256                               arm64_big_sur:  "0c7a97bdad728b2d0973323a49b23a8b47aec2575aa965b3b076d60fa56b9df7"
    sha256 cellar: :any_skip_relocation, ventura:        "3e35ab8e3cbd8c8103f72b54677601c4ec0b3e2bd422a1adb3dc0d38da7a6d00"
    sha256 cellar: :any_skip_relocation, monterey:       "19ef0751f3c6eb7db47c440534004cb88ac4f5dc4f7d58319ff33d929cdf8005"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cb67fb3e2738fd0bed737cc7c79a38b54e810bcb960dcaa356683c08ba1b80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fa5ecc964f2e60317130793a34e0e458a063edd2cf81b681c9af5c8d3a6964"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
