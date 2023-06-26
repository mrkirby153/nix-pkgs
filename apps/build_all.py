#!/usr/bin/env python3

from functools import lru_cache
from typing import Any, Dict, List, Iterable
from subprocess import run
import json
from pathlib import Path


SYSTEM = "x86_64-linux"

TO_BUILD = ["devShells", "packages"]


@lru_cache
def get_flake() -> Dict[str, Any]:
    cmd = ["nix", "flake", "show", "--json"]
    proc = run(cmd, capture_output=True)
    return json.loads(proc.stdout.decode("utf-8"))


def get_repo_root() -> Path:
    result = run(["git", "rev-parse", "--show-toplevel"], capture_output=True)
    return Path(result.stdout.decode("utf-8").strip()).absolute()


def get_derivations(data) -> Iterable[List[str]]:
    for k, v in data.items():
        if not isinstance(v, dict):
            continue  # Not a dict, skip
        if v.get("type") == "derivation":
            yield k
        else:
            yield from get_derivations(v)


def get_buildable_derivations(data) -> Iterable[List[str]]:
    for output_type in TO_BUILD:
        if flake.get(output_type):
            yield from get_derivations(flake[output_type][SYSTEM])


if __name__ == "__main__":
    repo_root = get_repo_root()
    print(f"Running in {repo_root}")
    print("Determining build targets...")
    flake = get_flake()
    derivations = list(get_buildable_derivations(flake))
    print(f"Building {len(derivations)} derivations")

    for derivation in derivations:
        print(f"== Building Derivation: {derivation} ==")
        run(
            [
                "nix",
                "build",
                "--no-link",
                "--print-build-logs",
                f"{repo_root}#{derivation}",
            ],
            cwd=repo_root,
            check=True,
        )
        print(f"== Finished Building Derivation: {derivation} ==")
