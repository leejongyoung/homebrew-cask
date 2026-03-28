class Treesnap < Formula
  desc "Track and version local file structures, sizes, and metadata"
  homepage "https://github.com/leejongyoung/TreeSnapshots"
  url "https://github.com/leejongyoung/TreeSnapshots/releases/download/v2.0.0/treesnap-macos-universal.tar.gz"
  sha256 "5562476f2352779102c3f03c9d91d456cedc8e466e6ff94b6a33dc1b9b70d916"
  license "MIT"

  def install
    bin.install "treesnap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treesnap --version")
  end
end
