---
name: fastapi-websockets
description: Build FastAPI WebSocket endpoints with authentication, lifecycle handling, and safe message validation.
---

# fastapi-websockets

## Purpose
Implement FastAPI WebSocket flows with explicit connection, authentication, validation, and cleanup behavior.

## Auto Activation
Use when editing `WebSocket`, `websocket_route`, connection managers, real-time notifications, chat, streaming updates, or WebSocket tests.

## Do Not Activate
Do not use for normal HTTP streaming or polling endpoints unless WebSockets are being introduced or changed.

## Detect
Look for `WebSocket`, `WebSocketDisconnect`, `accept()`, `receive_json`, `send_json`, connection managers, rooms, channels, and real-time broadcast code.

## Responsibilities
- Authenticate and authorize before accepting sensitive connections when possible.
- Validate every inbound message shape.
- Handle disconnects and cleanup subscriptions.
- Bound connection state and broadcast fan-out.
- Keep shared connection registries safe under concurrency.

## Never Do
- Trust client-sent user, tenant, room, or role values.
- Keep dead connections in memory after disconnect.
- Broadcast private data to unauthorized subscribers.
- Let malformed messages crash the connection manager.

## Cooperates With
fastapi, fastapi-authentication, fastapi-validation, async-python, security, testing, code-review.

## Final Checklist
- Connection auth and authorization are explicit.
- Inbound messages are validated.
- Disconnect cleanup removes state.
- Broadcast targets are permission-safe.
- WebSocket behavior has a focused check when practical.

## Examples
- Reject a WebSocket connection when its token cannot be mapped to a current user.
- Validate a chat message payload before broadcasting it to a room.
