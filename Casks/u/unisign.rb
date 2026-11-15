cask "unisign" do
  version "3.0.0"
  sha256 "40391e0982b0d8c96179002b0640463af34b26ee26fe2fc0042c4c51329cc68d"

  url "https://unisign.co.kr/EXE/install/UniSignCRSV3Setup.pkg"
  name "UniSign"
  desc "Cross-certification security program for Korean financial/education sites"
  homepage "https://unisign.co.kr/"

  depends_on :macos

  pkg "UniSignCRSV3Setup.pkg"

  uninstall pkgutil: "com.crosscert.*",
            delete:  [
              "/Library/Internet Plug-Ins/UniSign*",
              "/Library/LaunchAgents/com.crosscert.*",
              "/Library/LaunchDaemons/com.crosscert.*",
            ],
            trash:   [
              "~/Library/Application Support/UniSign",
              "~/Library/Caches/com.crosscert.*",
              "~/Library/Logs/UniSign",
              "~/Library/Preferences/com.crosscert.*",
            ]
end
