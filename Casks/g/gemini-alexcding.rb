cask "gemini-alexcding" do
  version "0.2.0"
  sha256 "6096abe9d25f4e4434f6c6a6b80da8424b0dc16e986188112993d89b8b1dd039"

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
