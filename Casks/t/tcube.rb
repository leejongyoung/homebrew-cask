cask "tcube" do
  version :latest
  sha256 :no_check

  url "https://lms.kmooc.kr/webcube/components/TCubeMac.pkg",
      verified: "lms.kmooc.kr/webcube/components/"
  name "TCube"
  desc "Browser-based virtualization solution for online exams"
  homepage "http://www.teruten.com/kr/solution/virtualization.php"

  pkg "TCubeMac.pkg"

  uninstall launchctl: "com.teruten.webserver",
            pkgutil:   "com.teruten.*",
            delete:    [
              "/Library/Internet Plug-Ins/CApkg.plugin",
              "/Library/Internet Plug-Ins/PopManager.app",
              "/Library/Internet Plug-Ins/PscProcSub.app",
              "/Library/Internet Plug-Ins/PscProcSubC.app",
              "/Library/Internet Plug-Ins/PscProcSubW.app",
              "/Library/Internet Plug-Ins/TerminateAlert.app",
              "/Library/Internet Plug-Ins/TerutenESAlert.app",
              "/Library/Internet Plug-Ins/TerutenLocalWebServer.app",
              "/Library/Internet Plug-Ins/TWMe.app",
              "/Library/Internet Plug-Ins/TWMo.app",
              "/Library/Internet Plug-Ins/WcbManager.app",
              "/Library/Internet Plug-Ins/WebServerWatch.app",
            ]
end
