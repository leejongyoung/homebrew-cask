cask "wizvera-delfino" do
  version :latest
  sha256 :no_check

  url "https://download.kbstar.com/security/wizvera/delfino/g3/delfino-g3.pkg"
  name "Wizvera Delfino G3"
  desc "Electronic signature and user authentication (Wizvera Delfino G3)"
  homepage "https://www.wizvera.com/"

  depends_on :macos

  pkg "delfino-g3.pkg"

  uninstall launchctl: "com.wizvera.delfino",
            pkgutil:   "com.wizvera.delfino",
            delete:    [
              "/Applications/Delfino",
              "/Library/LaunchAgents/com.wizvera.delfino.plist",
            ]

  zap trash: [
    "~/Library/Application Support/Delfino",
    "~/Library/Caches/com.wizvera.delfino",
    "~/Library/Logs/Delfino",
    "~/Library/Preferences/com.wizvera.delfino.plist",
  ]
end
