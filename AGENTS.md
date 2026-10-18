# AGENTS.md

이 저장소는 개인용 Homebrew tap(`brew tap leejongyoung/cask`)입니다.
Cask나 Formula를 추가하거나 수정할 때는 아래 규칙을 반드시 따릅니다.

---

## 저장소 구조

```
homebrew-cask/
├── .github/
│   ├── scripts/bump-formula.py   # Formula 버전·sha256 갱신 (autobump에서 사용)
│   └── workflows/
│       ├── ci.yml                # 바뀐 Cask·Formula의 style · audit
│       ├── autobump.yml          # 매일 livecheck → 새 버전이면 자동 커밋
│       ├── install-test.yml      # 수동 설치 테스트
│       └── sync-homebrew.yml     # Homebrew/homebrew-cask → homebrew 브랜치 동기화
├── Casks/
│   └── t/
│       ├── tcube.rb
│       ├── touchen-nxkey.rb
│       └── treesnapshots.rb
├── Formula/
│   └── t/
│       └── treesnapshots-cli.rb
├── AGENTS.md
├── CLAUDE.md                     # → @AGENTS.md
├── LICENSE
└── README.md
```

Cask는 `Casks/<첫글자>/`, Formula는 `Formula/<첫글자>/` 아래에 둡니다 (homebrew-cask · homebrew-core와 같은 구조).

`main` 브랜치가 tap 내용입니다. `homebrew` 브랜치는 공식 저장소를 매일 동기화한 사본이므로 직접 수정하지 않습니다.

---

## Cask 파일 작성 규칙

### 토큰 네이밍

- 디스크의 `.app` 이름 기준, `.app` 제거
- 소문자, 공백·언더스코어 → 하이픈
- 버전 번호·플랫폼 식별자(`for Mac` 등) 제거
- 비공식 포크나 대안 배포판은 원작자 식별자를 접미사로 붙임 (예: `<app>-<author>`)
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
depends_on       # macOS 전용 Cask는 `depends_on :macos` 필수 (brew style)
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

  depends_on :macos

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

버전이 있는 Cask와 Formula는 `autobump.yml`이 매일 확인해서 자동으로 커밋합니다. `version :latest` Cask는 대상이 아닙니다. 직접 올릴 때는 `version`과 `sha256`만 교체합니다. URL은 `#{version}` 보간을 사용하므로 수정 불필요합니다.

```bash
# 새 버전의 SHA256 계산
curl -fsSL <new-dmg-url> | shasum -a 256

# 파일 수정 후 검증
brew style --fix Casks/<첫글자>/<cask-name>.rb
brew audit --cask --online leejongyoung/cask/<cask-name>

# 통과 후 커밋
git add Casks/<첫글자>/<cask-name>.rb
git commit -m "chore: bump <cask-name> to <version>"
```

---

## Formula 작성 규칙

- 순서: `desc` → `homepage` → `url`/`sha256` → `license` → `depends_on` → `install` → `test`
- 플랫폼별 바이너리는 `if OS.mac? … else … end`로 `url`·`sha256`을 나눕니다. `on_macos`/`on_linux` 블록 안에는 `url`·`sha256`을 둘 수 없습니다(`brew style` 오류).
- 지원하지 않는 아키텍처는 `on_linux do depends_on arch: :x86_64 end`처럼 막습니다.
- `test do` 블록에서 `--version` 출력에 `version`이 들어 있는지 확인합니다.
- 검증:

  ```bash
  brew style --fix Formula/<첫글자>/<formula>.rb
  brew audit --formula --online leejongyoung/cask/<formula>
  ```

- 버전을 직접 올릴 때는 URL마다 sha256이 다르므로 `python3 .github/scripts/bump-formula.py <파일> <현재> <새 버전>`을 씁니다.

---

## 커밋 메시지 컨벤션

Conventional Commits 형식을 따릅니다.

| 접두어 | 사용 상황 |
|--------|----------|
| `feat` | 새 Cask · Formula 추가 |
| `fix` | Cask · Formula 오류 수정 (URL, sha256, app 경로 등) |
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

커밋 메시지에 AI 작성자 표시(`Co-Authored-By` 등)를 넣지 않습니다.
