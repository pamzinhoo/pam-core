"""Backward-compatible pam-core runtime entrypoint."""

from __future__ import annotations

import argparse
import json

from pam_core.config import get_settings
from pam_core.engine import PamCoreEngine
from pam_core.protocol.parser import run
from pam_core.runtime.loop import RuntimeLoop


def main() -> None:
    settings = get_settings()
    parser = argparse.ArgumentParser(description="Run the pam-core runtime engine.")
    parser.add_argument("--once", action="store_true", help="Run one engine cycle and exit.")
    parser.add_argument("--loop", action="store_true", help="Run the continuous engine loop.")
    parser.add_argument("--api", action="store_true", help="Run the FastAPI server.")
    parser.add_argument("--interval", default=settings.loop_interval, type=float, help="Loop interval in seconds.")
    parser.add_argument("--host", default=settings.host, help="API host.")
    parser.add_argument("--port", default=settings.port, type=int, help="API port.")
    parser.add_argument("--adapter", default=None, help="Runtime adapter: cli, claude, codex, or cursor.")
    args = parser.parse_args()

    if args.once:
        result = run(PamCoreEngine(settings))
        print(json.dumps(result, indent=2, sort_keys=True))
        return

    if args.loop:
        RuntimeLoop(
            PamCoreEngine(settings),
            interval=args.interval,
            adapter_name=args.adapter,
        ).run_forever()
        return

    from pam_core.api.server import create_app
    import uvicorn

    uvicorn.run(create_app(PamCoreEngine(settings)), host=args.host, port=args.port)


if __name__ == "__main__":
    main()
