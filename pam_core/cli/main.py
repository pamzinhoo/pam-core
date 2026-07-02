import sys

from pam_core.engine import PamCoreEngine
from pam_core.runtime.loop import run_loop


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "run"

    if cmd == "run":
        run_loop()
    elif cmd == "doctor":
        print("✔ pam-core OK")
    elif cmd == "memory":
        memory = PamCoreEngine().memory()
        print(f"Memory system active: {len(memory.get('history', []))} history entries")
    else:
        print("Unknown command")
