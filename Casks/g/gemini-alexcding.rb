cask "gemini-alexcding" do
  version "0.2.1"
  sha256 "794cbc3ecb092ac313fe1b31aea84c16bda718575d950b147164fbaea29fda42"

  url "https://github.com/alexcding/gemini-desktop-mac/releases/download/#{version}/GeminiDesktop.dmg"
  name "Gemini Desktop"
  desc "Unofficial desktop app for Gemini"
  homepage "https://github.com/alexcding/gemini-desktop-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "Gemini Desktop.app"

  zap trash: [
    "~/Library/Application Support/Gemini Desktop",
    "~/Library/Caches/com.alexcding.gemini-desktop",
    "~/Library/Logs/Gemini Desktop",
    "~/Library/Preferences/com.alexcding.gemini-desktop.plist",
  ]
end
