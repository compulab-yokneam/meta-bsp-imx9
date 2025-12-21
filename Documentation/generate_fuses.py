import sys
import re

def parse_od_output(od_output):
    """
    Parses the output of 'od -t x4 file.bin' and generates U-Boot fuse commands.
    """
    fuse_commands = []
    fuse_word_index = 0
    # Regular expression to find groups of 8-character hex words
    hex_pattern = re.compile(r'([0-9a-f]{8})')
    for line in od_output.splitlines():
        # Find all 8-character hex words in the line
        matches = hex_pattern.findall(line)
        for hex_word in matches:
            if fuse_word_index < 8:
                # The SRK Hash starts at bank 16, word 0, and uses 8 words
                command = f"fuse prog 16 {fuse_word_index} 0x{hex_word}"
                fuse_commands.append(command)
                fuse_word_index += 1
            else:
                break # after the 8th word
        if fuse_word_index >= 8:
            break
    return fuse_commands

output = sys.stdin.read()
print("### U-Boot Fusing Commands ###")
print("Copy and paste these commands one by one into the U-Boot console.")
print("---")
for cmd in parse_od_output(output):
    print(cmd)
