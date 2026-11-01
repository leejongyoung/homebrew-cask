cask "ahnlab-safe-transaction" do
  version :latest
  sha256 :no_check

  url "https://safetx.ahnlab.com/master/mac/astx.dmg"
  name "AhnLab Safe Transaction"
  desc "Keyboard security, antivirus/firewall and anti-phishing for banking"
  homepage "https://www.ahnlab.com/"

  depends_on macos: :monterey

  pkg "ASTx.pkg"

  uninstall launchctl: [
              "com.ahnlab.astxagent",
              "com.ahnlab.astxd",
            ],
            pkgutil:   [
              "com.ahnlab.astx.AhnLab.pkg",
              "com.ahnlab.astxagent.pkg",
              "com.ahnlab.astxd.pkg",
            ],
            delete:    [
              "/Applications/AhnLab/ASTx",
              "/Library/LaunchAgents/com.ahnlab.astxagent.plist",
              "/Library/LaunchDaemons/com.ahnlab.astxd.plist",
            ]

  zap trash: [
    "~/Library/Application Support/ASTx",
    "~/Library/Caches/com.ahnlab.astx",
    "~/Library/Logs/ASTx",
    "~/Library/Preferences/com.ahnlab.astx.plist",
  ]
end
