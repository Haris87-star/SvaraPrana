# -*- coding: utf-8 -*-
"""
SvaraPrana Complete Index Generator & Synchronizer
Ensures byte-for-byte synchronization between index.html and public/index.html
along with all assets, icons, and manifests with zero JavaScript syntax errors.
"""

import os
import shutil
import re
import subprocess

def main():
    print("=" * 60)
    print("SvaraPrana Production Build: Synchronizing files -> public/")
    print("=" * 60)

    root_index = os.path.abspath("index.html")
    public_dir = os.path.abspath("public")
    public_index = os.path.join(public_dir, "index.html")

    if not os.path.exists(root_index):
        raise FileNotFoundError("Root index.html not found!")

    if not os.path.exists(public_dir):
        os.makedirs(public_dir)
        print("Created public/ directory.")

    # 1. Copy index.html to public/index.html
    shutil.copy2(root_index, public_index)
    print(f"Copied {root_index} -> {public_index}")
    print(f"File size: {os.path.getsize(public_index):,} bytes")

    # 2. Sync assets/ to public/assets/
    if os.path.exists("assets"):
        public_assets = os.path.join(public_dir, "assets")
        os.makedirs(public_assets, exist_ok=True)
        for root, dirs, files in os.walk("assets"):
            rel = os.path.relpath(root, "assets")
            target_dir = os.path.join(public_assets, rel)
            os.makedirs(target_dir, exist_ok=True)
            for f in files:
                shutil.copy2(os.path.join(root, f), os.path.join(target_dir, f))
        print("Synchronized assets/ -> public/assets/")

    # 3. Sync manifest.json & favicon.png
    for f in ["manifest.json", "favicon.png"]:
        if os.path.exists(f):
            shutil.copy2(f, os.path.join(public_dir, f))
            print(f"Synchronized {f} -> public/{f}")

    # 4. Validate syntax with Node.js
    with open(root_index, "r", encoding="utf-8") as f:
        html = f.read()

    scripts = re.findall(r'<script(?:\s+[^>]*)?>(.*?)</script>', html, re.DOTALL | re.IGNORECASE)
    print(f"Validating {len(scripts)} embedded JavaScript script blocks...")

    for i, s in enumerate(scripts):
        if not s.strip():
            continue
        test_js = os.path.join("scratch", f"validate_script_{i}.js")
        os.makedirs("scratch", exist_ok=True)
        with open(test_js, "w", encoding="utf-8") as sf:
            sf.write(s)
        res = subprocess.run(["node", "--check", test_js], capture_output=True, text=True)
        if res.returncode == 0:
            print(f"  Script block {i} ({len(s):,} chars): SYNTAX VALIDATED OK")
        else:
            print(f"  Script block {i} ERROR:\n{res.stderr}")
            raise SyntaxError(f"JavaScript syntax error in script block {i}")

    print("=" * 60)
    print("[SUCCESS] Build completed successfully! Ready for Vercel and Netlify deployment.")
    print("=" * 60)

if __name__ == "__main__":
    main()
