#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.tqdm

import re
from collections import defaultdict
from pathlib import Path

from tqdm import tqdm

# Path to the /nix/store
nix_store_path = Path("/nix/store")

# Regular expression to match package names in the format <package-name>-<version>
package_regex = re.compile(r"^.+-([a-zA-Z0-9\-_]+)-(\d+\.\d+\.\d+)$")

# Dictionary to store packages and their versions
packages = defaultdict(list)

# Get the list of all directories in /nix/store
all_dirs = list(nix_store_path.iterdir())

# Iterate through the /nix/store directory with a progress bar
for path in tqdm(all_dirs, desc="Scanning /nix/store"):
    if path.is_dir():
        match = package_regex.match(path.name)
        if match:
            print(match.groups())
            package_name = match.group(1)
            package_version = match.group(2)
            packages[package_name].append((package_version, path))

print(len(packages))
# Display results

for package_name, versions in packages.items():
    if len(versions) > 1:
        print(f"Package: {package_name}")
        for version, path in versions:
            print(f"  Version: {version}, Path: {path}")
