cask "treesnapshots" do
  version "2.0.0"
  sha256 "09e91d9f9425d069105686b102e7b36c5a97a3b2bc2b92fec262c286bc936442"

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
