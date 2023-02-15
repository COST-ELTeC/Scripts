"""
Script to update all repos automatically. 
Either do a pull, or a push, for a list of repos. 
"""


import subprocess 
from os.path import join


action = "push" # pull/push

basefolder = join("/", "media", "christof", "Data", "Github", "eltec", "")

repos = [
    "ELTeC-cze",
    "ELTeC-deu",
    "ELTeC-eng",
    "ELTeC-eng-ext",
    "ELTeC-fra",
    "ELTeC-fra-ext1",
    "ELTeC-fra-ext2",
    "ELTeC-fra-ext3",
    "ELTeC-gsw",
    "ELTeC-hrv",
    "ELTeC-hun",
    "ELTeC-ita",
    "ELTeC-lav",
    "ELTeC-lit",
    "ELTeC-nld",
    "ELTeC-nor",
    "ELTeC-nor-ext",
    "ELTeC-pol",
    "ELTeC-por",
    "ELTeC-por-ext",
    "ELTeC-rom",
    "ELTeC-rus",
    "ELTeC-slv",
    "ELTeC-spa",
    "ELTeC-srp",
    "ELTeC-srp-ext",
    "ELTeC-swe",
    "ELTeC-ukr",
]


def execute_command(fullpath):
    if action == "pull":
        command = "cd " + fullpath
        subprocess.run(command, shell=True)
        command = "git pull"
        subprocess.run(command, shell=True)
    elif action == "push": 
        command = "cd " + fullpath
        subprocess.run(command, shell=True)
        command = "git add -A"
        subprocess.run(command, shell=True)
        command = "git commit -m \"metadata update\""
        subprocess.run(command, shell=True)
        command = "git push"
        subprocess.run(command, shell=True)


def main(): 
    for repo in repos:
        fullpath = join(basefolder, repo) 
        execute_command(fullpath)

main()