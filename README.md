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
brew install --cask leejongyoung/cask/treesnapshots

# Formula (CLI 도구) 설치
brew install leejongyoung/cask/treesnapshots-cli
```

> GitHub 저장소 이름이 `homebrew-cask`이면 `brew tap leejongyoung/cask`로 등록됩니다.

---

## Cask 목록

| Cask 토큰 | 앱 이름 | 버전 | 설명 |
|-----------|---------|:----:|------|
| [`touchen-nxkey`](Casks/t/touchen-nxkey.rb) | TouchEn nxKey | latest | Keyboard security software that blocks keyloggers |
| [`tcube`](Casks/t/tcube.rb) | TCube | 4.71 | Browser-based virtualization solution for online exams |
| [`treesnapshots`](Casks/t/treesnapshots.rb) | TREESNAPSHOTS | 2.0.3 | Track and version local file structures, sizes, and metadata |
| [`unisign`](Casks/u/unisign.rb) | UniSign | 3.0.0 | Cross-certification security program for Korean financial/education sites |
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
brew install --cask leejongyoung/cask/treesnapshots

# 업그레이드
brew upgrade --cask leejongyoung/cask/treesnapshots

# 삭제
brew uninstall --cask leejongyoung/cask/treesnapshots

# 완전 삭제 — 앱 데이터·캐시·설정 파일까지 제거 (zap)
brew uninstall --zap --cask leejongyoung/cask/treesnapshots
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
brew info --cask leejongyoung/cask/treesnapshots  # Cask 상세 정보
brew info leejongyoung/cask/treesnapshots-cli  # Formula 상세 정보
```

---

## 버전 업데이트

**자동** — `autobump.yml`이 매일 18:00(KST)에 모든 Cask와 Formula를 `brew livecheck`로 확인합니다. 새 버전이 있으면 `version`과 `sha256`을 고쳐서 `main`에 바로 커밋합니다. Formula는 macOS·Linux URL마다 sha256을 따로 계산합니다.

`version :latest`인 Cask(`tcube`, `touchen-nxkey`)는 항상 배포처의 최신 파일을 받으므로 자동 업데이트 대상이 아닙니다.

**수동** — 자동 업데이트가 실패했거나 바로 올리고 싶을 때:

```bash
# Cask: version과 sha256 두 줄만 교체 (URL은 #{version} 보간)
curl -fsSL <새 버전 다운로드 URL> | shasum -a 256

# Formula: URL마다 sha256을 계산해 교체
python3 .github/scripts/bump-formula.py Formula/t/treesnapshots-cli.rb 2.0.3 2.0.4

# 검증 후 커밋
brew style --fix Casks/<첫글자>/<cask>.rb
brew audit --cask --online leejongyoung/cask/<cask>
git commit -am "chore: bump <cask> to <version>"
```

로컬 반영:

```bash
brew update && brew upgrade --cask leejongyoung/cask/<cask>
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
| `depends_on` | macOS 전용이면 `depends_on :macos` (최신 `brew style` 필수) |
| artifact | 설치 대상 선언 (`app`, `pkg`, `binary` 중 하나 이상) |

### 스탠자 작성 순서

Cask Cookbook 권장 순서를 따릅니다.

```
version → sha256 → url → name → desc → homepage → (livecheck) → depends_on → (artifact) → (uninstall) → zap
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

  depends_on :macos

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

## 브랜치

| 브랜치 | 내용 |
|--------|------|
| `main` | 이 tap의 Cask · Formula · 워크플로 |
| `homebrew` | `sync-homebrew.yml`이 매일 공식 [Homebrew/homebrew-cask](https://github.com/Homebrew/homebrew-cask)를 동기화한 사본 (직접 수정하지 않음) |

---

## License

[MIT](./LICENSE) © leejongyoung
