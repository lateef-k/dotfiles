#!/usr/bin/env python3


import sys
from pathlib import Path
import pdb

def annotate_file_text(path):
    if Path(path).is_dir():
        return

    with open(path, "r") as file:
        return "".join([f"{path}:{i}:{line}" for i,line in enumerate(file.readlines())])
    

if __name__ == "__main__":
    for file in Path(".").rglob("*"):
        try:
            res = annotate_file_text(file)
            if res:
                print(res)
        except Exception as e:
            continue
