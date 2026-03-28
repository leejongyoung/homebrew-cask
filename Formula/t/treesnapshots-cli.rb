class TreesnapshotsCli < Formula
  desc "Track and version local file structures, sizes, and metadata"
  homepage "https://github.com/leejongyoung/TreeSnapshots"
  license "MIT"

  if OS.mac?
    url "https://github.com/leejongyoung/TreeSnapshots/releases/download/v2.0.3/treesnapshots-cli-macos-universal.tar.gz"
    sha256 "bb0ad353c37f95386402c9df5bf90bb168015b2db8517a8be192e1c7cf399dd8"
  else
    url "https://github.com/leejongyoung/TreeSnapshots/releases/download/v2.0.3/treesnapshots-cli-linux-x86_64.tar.gz"
    sha256 "cd0e855b05dbeaadd43f4509cee6afeb20bcf9c68ea2c5c554282a77e3da83db"
  end

  def install
    bin.install "treesnapshots-cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/treesnapshots-cli --version")
  end
end
