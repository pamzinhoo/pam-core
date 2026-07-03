"""Run pam-core API server with python -m pam_core.server."""

from __future__ import annotations

import argparse

import uvicorn

from pam_core.config import get_settings
from pam_core.server.app import create_app


def main() -> None:
    settings = get_settings()
    parser = argparse.ArgumentParser(description="Run the pam-core API server.")
    parser.add_argument("--host", default=settings.host, help="API host.")
    parser.add_argument("--port", default=settings.port, type=int, help="API port.")
    args = parser.parse_args()

    uvicorn.run(create_app(settings), host=args.host, port=args.port)


if __name__ == "__main__":
    main()
