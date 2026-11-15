cask "tcube" do
  version "4.71"
  sha256 "c12b48efb0fdfe06059cb2d7b3434f1abf76676c285ab90e979902efe56e5117"

  url "https://lms.kmooc.kr/webcube/components/TCubeMac.pkg"
  name "TCube"
  desc "Browser-based virtualization solution for online exams"
  homepage "https://www.teruten.com/kr/solution/virtualization.php"

  depends_on :macos

  pkg "TCubeMac.pkg"

  uninstall launchctl: "com.teruten.localwebserver",
            pkgutil:   "com.teruten.*",
            delete:    [
              "/Library/Internet Plug-Ins/CApkg.plugin",
              "/Library/Internet Plug-Ins/PopManager.app",
              "/Library/Internet Plug-Ins/PscProcSub.app",
              "/Library/Internet Plug-Ins/PscProcSubC.app",
              "/Library/Internet Plug-Ins/PscProcSubW.app",
              "/Library/Internet Plug-Ins/TerminateAlert.app",
              "/Library/Internet Plug-Ins/TerutenCert.crt",
              "/Library/Internet Plug-Ins/TerutenESAlert.app",
              "/Library/Internet Plug-Ins/TerutenMacWebServer.app",
              "/Library/Internet Plug-Ins/TWMe.app",
              "/Library/Internet Plug-Ins/TWMo.app",
              "/Library/Internet Plug-Ins/WcbManager.app",
              "/Library/Internet Plug-Ins/WebServerWatch.app",
              "/Library/LaunchAgents/com.teruten.localwebserver.plist",
              "/Library/LaunchAgents/com.teruten.localwebserver2.plist",
            ],
            trash:     [
              "~/Library/Application Support/TCube",
              "~/Library/Caches/com.teruten.*",
              "~/Library/Logs/TCube",
              "~/Library/Preferences/com.teruten.*",
            ]
end
