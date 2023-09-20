import re
import subprocess

output_regexp = re.compile(r"\s([^\s]+): command not found")
command_not_found_regexp = re.compile(r"nix-shell -p ([^\s]*)")

enabled_by_default = True
priority = 2000


def match(command):
    return output_regexp.search(command.output)


def get_new_command(command):
    program = output_regexp.search(command.output).group(1)
    command_not_found_subprocess = subprocess.run(
        ["command-not-found", program], capture_output=True, text=True
    )
    packages = command_not_found_regexp.findall(command_not_found_subprocess.stderr)
    return [f"nix-shell -p {package}" for package in packages]
