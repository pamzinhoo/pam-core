import sys
import json

from pam_core.config import get_settings
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
    elif cmd == "serve":
        settings = get_settings()
        host = _option_value("--host", settings.host)
        try:
            port = int(_option_value("--port", str(settings.port)))
        except ValueError:
            print("Invalid --port value; expected an integer.", file=sys.stderr)
            raise SystemExit(2)
        from pam_core.server.app import create_app
        import uvicorn

        uvicorn.run(create_app(settings), host=host, port=port)
    else:
        result = call(" ".join(sys.argv[1:]).strip(), PamCoreEngine())
        print(json.dumps(result, indent=2, sort_keys=True))


def _option_value(name: str, default: str) -> str:
    if name not in sys.argv:
        return default
    index = sys.argv.index(name)
    if index + 1 >= len(sys.argv):
        return default
    return sys.argv[index + 1]
