cask "treesnapshots" do
  version "2.0.3"
  sha256 "e2130faf5093a3023ba49eed8e44e1ff3c6acf14778dbb8156db07d6f23a90d9"

  url "https://github.com/leejongyoung/TreeSnapshots/releases/download/v#{version}/TREESNAPSHOTS_#{version}_universal.dmg"
  name "TREESNAPSHOTS"
  desc "Track and version local file structures, sizes, and metadata"
  homepage "https://github.com/leejongyoung/TreeSnapshots"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "TREESNAPSHOTS.app"

  zap trash: [
    "~/Library/Application Support/TREESNAPSHOTS",
    "~/Library/Caches/com.treesnapshots.app",
    "~/Library/Logs/TREESNAPSHOTS",
    "~/Library/Preferences/com.treesnapshots.app.plist",
  ]
end
