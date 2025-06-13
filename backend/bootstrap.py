import os
import shutil
import subprocess
from zipfile import ZipFile

output_zip = "fastapi.zip"
build_dir = "build"

# Clean up
shutil.rmtree(build_dir, ignore_errors=True)
os.makedirs(build_dir)

# Install dependencies
subprocess.run([
    "pip", "install", "-r", "app/requirements.txt", "--target", build_dir
])

# Copy source
shutil.copytree("app", os.path.join(build_dir, "app"))
shutil.copy("app/main.py", os.path.join(build_dir, "main.py"))

# Zip
with ZipFile(output_zip, "w") as zipf:
    for root, _, files in os.walk(build_dir):
        for file in files:
            filepath = os.path.join(root, file)
            arcname = os.path.relpath(filepath, build_dir)
            zipf.write(filepath, arcname)

print(f" Created {output_zip}")
