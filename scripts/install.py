#!/usr/bin/env python3
"""Install both repository packages as Typst local-package symlinks."""
from datetime import datetime
import os
from pathlib import Path
import tomllib

REPO = Path(__file__).resolve().parents[1]
DATA = Path(os.environ.get("XDG_DATA_HOME") or Path.home() / ".local/share")
LOCAL = DATA / "typst/packages/local"


def install(name):
    source = REPO / name / "0.1.0"
    metadata = tomllib.loads((source / "typst.toml").read_text())["package"]
    assert metadata["name"] == name
    target = LOCAL / name / metadata["version"]
    if target.is_symlink() and target.resolve() == source:
        print(f"Already installed: {target} -> {source}")
        return
    target.parent.mkdir(parents=True, exist_ok=True)
    if target.exists() or target.is_symlink():
        stamp = datetime.now().strftime("%Y%m%d-%H%M%S-%f")
        backup = DATA / "typst/package-backups" / f"{name}-{metadata['version']}-{stamp}"
        backup.parent.mkdir(parents=True, exist_ok=True)
        target.rename(backup)
        print(f"Preserved previous installation: {backup}")
    target.symlink_to(source, target_is_directory=True)
    print(f"Installed: {target} -> {source}")


if __name__ == "__main__":
    for package in ("note", "pre"):
        install(package)
