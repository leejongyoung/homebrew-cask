<div align="center">

# 🍺 homebrew-cask

**개인용 Homebrew Cask & Formula 저장소**

공식 Homebrew에 등록되지 않은 앱과 CLI 도구를 `brew` 명령어로 설치·관리합니다.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)
[![macOS](https://img.shields.io/badge/macOS-supported-blue?logo=apple)](https://brew.sh)

</div>

---

## 빠른 시작

```bash
brew tap leejongyoung/cask

# Cask (GUI 앱) 설치
brew install --cask gemini-alexcding

# Formula (CLI 도구) 설치
brew install leejongyoung/cask/treesnapshots-cli
```

> GitHub 저장소 이름이 `homebrew-cask`이면 `brew tap leejongyoung/cask`로 등록됩니다.

---

## Cask 목록

| Cask 토큰 | 앱 이름 | 버전 | 설명 |
|-----------|---------|:----:|------|
| [`gemini-alexcding`](Casks/g/gemini-alexcding.rb) | Gemini Desktop | 0.2.0 | Unofficial desktop app for Gemini |
| [`touchen-nxkey`](Casks/t/touchen-nxkey.rb) | TouchEn nxKey | latest | Keyboard Security Solution (Anti-Keylogger) |
| [`tcube`](Casks/t/tcube.rb) | TCube | latest | Browser-based virtualization solution for online exams |
| [`treesnapshots`](Casks/t/treesnapshots.rb) | TREESNAPSHOTS | 2.0.3 | Track and version local file structures, sizes, and metadata |

---

## Formula 목록

| Formula 토큰 | 버전 | 설명 |
|--------------|:----:|------|
| [`treesnapshots-cli`](Formula/t/treesnapshots-cli.rb) | 2.0.3 | Track and version local file structures, sizes, and metadata |

---

## 사용법

### Tap 등록

```bash
brew tap leejongyoung/cask
```

### Cask 설치 · 삭제

```bash
# 설치
brew install --cask gemini-alexcding

# 업그레이드
brew upgrade --cask gemini-alexcding

# 삭제
brew uninstall --cask gemini-alexcding

# 완전 삭제 — 앱 데이터·캐시·설정 파일까지 제거 (zap)
brew uninstall --zap --cask gemini-alexcding
```

### Formula 설치 · 삭제

```bash
# 설치
brew install leejongyoung/cask/treesnapshots-cli

# 업그레이드
brew upgrade leejongyoung/cask/treesnapshots-cli

# 삭제
brew uninstall treesnapshots-cli
```

### 상태 확인

```bash
brew list --cask          # 설치된 Cask 목록
brew list --formula       # 설치된 Formula 목록
brew outdated             # 업데이트 가능한 패키지 확인
brew info --cask gemini-alexcding        # Cask 상세 정보
brew info leejongyoung/cask/treesnapshots-cli  # Formula 상세 정보
```

---

## Cask 업데이트

새 버전이 릴리스됐을 때 아래 순서로 Cask 파일을 업데이트합니다.

**1단계 — SHA256 체크섬 계산**

```bash
curl -fsSL https://github.com/alexcding/gemini-desktop-mac/releases/download/<VERSION>/GeminiDesktop.dmg \
  | shasum -a 256
```

**2단계 — `Casks/gemini-alexcding.rb` 수정**

`version`과 `sha256` 두 줄만 교체합니다. URL은 `#{version}` 보간을 사용하므로 별도 수정이 불필요합니다.

```ruby
version "<NEW_VERSION>"
sha256  "<NEW_SHA256>"
```

**3단계 — 커밋 & Push**

```bash
git add Casks/gemini-alexcding.rb
git commit -m "chore: bump gemini-alexcding to <VERSION>"
git push
```

**4단계 — 로컬 반영**

```bash
brew update && brew upgrade --cask gemini-alexcding
```

---

## 새 Cask 추가

### Cask 토큰 규칙

[Cask Cookbook](https://docs.brew.sh/Cask-Cookbook)의 네이밍 규칙을 따릅니다.

- 디스크의 `.app` 이름 기준, `.app` 확장자 제거
- 소문자로 변환, 공백·언더스코어는 하이픈으로
- 버전 번호·플랫폼 식별자 제거 (`for Mac` 등)
- 개발 채널은 접미사 사용 (예: `app-name@beta`)

### 필수 스탠자

| 스탠자 | 설명 |
|--------|------|
| `version` | 릴리스 버전. 버전 정보가 없으면 `:latest` |
| `sha256` | `shasum -a 256`으로 계산한 체크섬. 불가능한 경우 `:no_check` |
| `url` | HTTPS 다운로드 URL. `#{version}` 보간 권장 |
| `name` | 앱의 공식 전체 이름 |
| `desc` | 80자 이내 한 줄 설명. 마케팅 문구·플랫폼 언급 지양 |
| `homepage` | 공식 홈페이지 |
| artifact | 설치 대상 선언 (`app`, `pkg`, `binary` 중 하나 이상) |

### 스탠자 작성 순서

Cask Cookbook 권장 순서를 따릅니다.

```
version → sha256 → url → name → desc → homepage → (artifact) → zap
```

### 템플릿

```ruby
cask "<cask-name>" do
  version "<version>"
  sha256 "<sha256-checksum>"

  url "https://example.com/releases/#{version}/App.dmg"
  name "<App Display Name>"
  desc "<80자 이내 설명>"
  homepage "https://example.com"

  app "<App Name>.app"

  zap trash: [
    "~/Library/Application Support/<App Name>",
    "~/Library/Preferences/com.<developer>.<app>.plist",
    "~/Library/Caches/com.<developer>.<app>",
  ]
end
```

SHA256 체크섬 계산:

```bash
curl -fsSL <download-url> | shasum -a 256
```

---

## License

[MIT](./LICENSE) © leejongyoung
