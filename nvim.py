import subprocess
import shutil
import os
import time

def git_clone(repo_url, destination):
    try:
        subprocess.run(['git', 'clone', repo_url, destination], check=True)
    except subprocess.CalledProcessError:
        print("Git clone failed. Retrying...")
        time.sleep(2)
        git_clone(repo_url, destination)

def build_and_install_nvim():
    try:
        subprocess.run(['cd', 'neovim', '&&', 'make', 'CMAKE_BUILD_TYPE=RelWithDebInfo'], shell=True, check=True)
        subprocess.run(['cd', 'build', '&&', 'cpack', '-G', 'DEB'], shell=True, check=True)
        subprocess.run(['sudo', 'dpkg', '-i', 'nvim-linux64.deb'], check=True)
    except subprocess.CalledProcessError as e:
        print(f"Error during build and installation: {e}")

def main():
    repo_url = "https://github.com/neovim/neovim.git"
    destination = "neovim"

    git_clone(repo_url, destination)

    os.chdir(destination)
    build_and_install_nvim()

if __name__ == "__main__":
    main()

