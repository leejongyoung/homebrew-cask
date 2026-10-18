#!/usr/bin/env python3
"""Bump a formula from one version to another.

Usage: bump-formula.py <formula.rb> <current> <latest>

Replaces <current> with <latest> on every url line, downloads each new url,
and writes its sha256 to the next sha256 line. Exits non-zero if any
download fails, leaving the file untouched.
"""

import hashlib
import re
import sys
import urllib.request
from pathlib import Path

URL = re.compile(r'^(\s*url\s+")([^"]+)(".*)$')
SHA = re.compile(r'^(\s*sha256\s+")([0-9a-f]{64})(".*)$')


def sha256_of(url: str) -> str:
    digest = hashlib.sha256()
    with urllib.request.urlopen(url, timeout=300) as response:
        for chunk in iter(lambda: response.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    path, current, latest = Path(sys.argv[1]), sys.argv[2], sys.argv[3]
    lines = path.read_text().splitlines(keepends=True)
    pending = None
    for i, line in enumerate(lines):
        if m := URL.match(line):
            new_url = m.group(2).replace(current, latest)
            print(f"Downloading: {new_url}", flush=True)
            pending = sha256_of(new_url)
            lines[i] = m.group(1) + new_url + m.group(3) + ("\n" if line.endswith("\n") else "")
        elif (m := SHA.match(line)) and pending:
            lines[i] = m.group(1) + pending + m.group(3) + ("\n" if line.endswith("\n") else "")
            pending = None
    path.write_text("".join(lines))
    print(f"=== Updated {path} ===")
    print(path.read_text())


if __name__ == "__main__":
    main()
