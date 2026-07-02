import sys
import json

from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import call, doctor, memory
from pam_core.runtime.loop import run_loop


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "run"

    if cmd == "run":
        run_loop()
    elif cmd == "call":
        natural_language_input = " ".join(sys.argv[2:]).strip()
        result = call(natural_language_input, PamCoreEngine())
        print(json.dumps(result, indent=2, sort_keys=True))
    elif cmd == "doctor":
        print(json.dumps(doctor(PamCoreEngine()), indent=2, sort_keys=True))
    elif cmd == "memory":
        print(json.dumps(memory(PamCoreEngine()), indent=2, sort_keys=True))
    else:
        result = call(" ".join(sys.argv[1:]).strip(), PamCoreEngine())
        print(json.dumps(result, indent=2, sort_keys=True))
