cask "yoondisk-https-mac" do
  version "4.0"
  sha256 :no_check

  url "https://cb.egreen.co.kr/myclass/studypcinfo/mac_address/Yoondisk_Https_mac.pkg",
      user_agent: :fake
  name "Yoondisk Html_Mac"
  desc "Local helper that reports the hardware address to e그린 computer registration"
  homepage "https://www.yoondisk.co.kr/"

  depends_on :macos

  pkg "Yoondisk_Https_mac.pkg"

  uninstall launchctl: "com.yoondisk.https_mac",
            script:    {
              executable:   "/usr/bin/security",
              args:         ["delete-certificate", "-c", "YOONDISK.INC.Mac_Adress",
                             "/Library/Keychains/System.keychain"],
              sudo:         true,
              must_succeed: false,
            },
            pkgutil:   "kr.co.yoondisk.html.macadress",
            delete:    [
              "/Applications/Yoondisk_HTTPS_Mac",
              "/Library/Frameworks/yoondisk",
              "/Library/LaunchDaemons/com.yoondisk.https_mac.plist",
            ]

  caveats <<~EOS
    The installer adds the "YOONDISK.INC.Mac_Adress" certificate authority to the
    System keychain as a trusted root, so the e그린 page can reach https://127.0.0.1:10028.
    It has no name constraints. Install it only while registering the computer and
    remove it afterwards:

      brew uninstall --cask leejongyoung/cask/yoondisk-https-mac

    Before installing, confirm the downloaded package is the notarized vendor build
    (the older Yoondisk_MacAdress.pkg has a revoked signature):

      spctl --assess --type install -vv <package>   # origin=Developer ID Installer: YOONDISK Co., Ltd (N7M583N7Z8)

    The helper binary is x86_64; Apple silicon needs Rosetta 2.
  EOS
end
