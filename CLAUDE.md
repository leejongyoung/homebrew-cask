# CLAUDE.md

이 저장소는 개인용 Homebrew Cask 저장소입니다.
Cask 파일을 추가하거나 수정할 때는 아래 규칙을 반드시 따릅니다.

---

## 편집 가이드

- 파일의 간단한 텍스트 치환이나 라인 수정 시, 전체 파일을 다시 쓰기보다 `sed` 명령어를 우선적으로 사용하세요.
- `sed -i`를 사용하여 파일을 직접 수정하고, 복잡한 정규표현식이 필요한 경우에도 `sed`를 지향하세요.
- `sed` 사용이 불가능하거나 너무 복잡한 경우에만 다른 편집 도구를 사용하세요.

---

## 저장소 구조

```
homebrew-cask/
├── Casks/
│   ├── g/
│   │   └── gemini-alexcding.rb
│   └── t/
│       └── touchen-nxkey.rb
├── CLAUDE.md
├── GEMINI.md
├── LICENSE
└── README.md
```

Cask 파일은 `Casks/<첫글자>/` 하위 디렉토리에 위치합니다 (homebrew-cask 동일 구조).

---

## Cask 파일 작성 규칙

### 토큰 네이밍

- 디스크의 `.app` 이름 기준, `.app` 제거
- 소문자, 공백·언더스코어 → 하이픈
- 버전 번호·플랫폼 식별자(`for Mac` 등) 제거
- 비공식 포크나 대안 배포판은 원작자 식별자를 접미사로 붙임 (예: `gemini-alexcding`)
- 개발 채널은 `@` 접미사 사용 (예: `app-name@beta`)

### 스탠자 작성 순서

반드시 아래 순서를 지킵니다 ([Cask Cookbook](https://docs.brew.sh/Cask-Cookbook) 기준).

```
version
sha256
url
name
desc
homepage
livecheck        # 선택
(artifact: app / pkg / binary)
uninstall        # pkg 사용 시 필수
zap
```

### 각 스탠자 규칙

**`version`**
- 릴리스 버전 문자열 그대로 사용
- 버전 정보가 없는 경우에만 `:latest`
- `:latest` 사용 시 `livecheck`와 `no_autobump!`를 함께 선언하지 않음
  — `version :latest`와 `livecheck`의 조합은 `no_autobump_defined`를 두 번 설정해 audit 에러 발생

**`sha256`**
- `curl -fsSL <url> | shasum -a 256` 으로 계산
- 체크섬 확인이 불가한 경우에만 `:no_check`

**`url`**
- HTTPS 필수
- `#{version}` 보간을 사용해 버전 업데이트 시 `url` 수정 불필요하게 작성
- URL 도메인이 `homepage` 도메인과 다를 경우 `verified:` 파라미터 필수
  ```ruby
  url "https://other-domain.com/path/App.pkg",
      verified: "other-domain.com/path/"
  ```

**`name`**
- 앱의 공식 전체 이름

**`desc`**
- 80자 이내 한 줄 설명
- 마케팅 문구·플랫폼 언급(`for macOS` 등) 지양
- 대문자로 시작, 마침표 없이 종료

**`homepage`**
- 앱의 공식 홈페이지 또는 GitHub 저장소 URL

**`app`**
- `.app` 번들 이름을 정확히 명시 (대소문자 포함)

**`zap`**
- `brew uninstall --zap` 시 제거할 사용자 데이터 경로 목록
- 일반적으로 포함되는 경로:
  - `~/Library/Application Support/<App Name>`
  - `~/Library/Preferences/com.<developer>.<app>.plist`
  - `~/Library/Caches/com.<developer>.<app>`
  - `~/Library/Logs/<App Name>` (해당하는 경우)

### 템플릿

```ruby
cask "<cask-token>" do
  version "<version>"
  sha256 "<sha256>"

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

---

## 검증 (Cask 추가·수정 후 필수)

Cask 파일을 추가하거나 수정한 뒤에는 반드시 아래 두 명령을 통과해야 커밋합니다.

```bash
# 스타일 자동 수정 — 오펜스 0건이어야 함
brew style --fix Casks/<첫글자>/<cask-name>.rb

# 감사 — 에러 0건이어야 함 (온라인 URL 유효성 포함)
brew audit --cask --online leejongyoung/cask/<cask-name>
```

- `brew style` — RuboCop 기반 코드 스타일 검사. `--fix`로 자동 수정 후 잔여 오펜스가 없어야 합니다.
- `brew audit --online` — 스탠자 누락, URL 접근 가능 여부, sha256 일치 여부 등을 검사합니다.

두 명령 모두 통과한 상태에서만 커밋합니다.

---

## Cask 버전 업데이트

`version`과 `sha256`만 교체합니다. URL은 `#{version}` 보간을 사용하므로 수정 불필요합니다.

```bash
# 새 버전의 SHA256 계산
curl -fsSL <new-dmg-url> | shasum -a 256

# 파일 수정 후 검증
brew style --fix Casks/<cask-name>.rb
brew audit --cask --online Casks/<cask-name>.rb

# 통과 후 커밋
git add Casks/<cask-name>.rb
git commit -m "chore: bump <cask-name> to <version>"
```

---

## 커밋 메시지 컨벤션

Conventional Commits 형식을 따릅니다.

| 접두어 | 사용 상황 |
|--------|----------|
| `feat` | 새 Cask 추가 |
| `fix` | Cask 오류 수정 (URL, sha256, app 경로 등) |
| `chore` | 버전 업데이트 |
| `docs` | README, CLAUDE.md 등 문서 수정 |
| `refactor` | Cask 구조 개선 (동작 변경 없음) |

예시:
```
feat: add <cask-name> cask
fix: correct app path in <cask-name>
chore: bump <cask-name> to <version>
docs: update README installation guide
```
