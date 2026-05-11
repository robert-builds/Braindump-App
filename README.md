# Braindump App

Braindump is a local-first, privacy-centered thought capture and weekly reflection app. The MVP is designed for iOS first and focuses on fast text or voice capture, local-only processing, Markdown-based ownership, and calm weekly reviews.

## MVP Principles

- **Privacy first:** local data, no accounts, no mandatory cloud, no telemetry, and no external AI calls.
- **Frictionless capture:** one-tap text and voice entry without folders or required structure.
- **Calm technology:** no gamification, social mechanics, productivity pressure, or constant analysis.
- **User ownership:** Markdown files and open metadata formats remain exportable and portable.

## Planned Stack

- **Frontend:** Flutter
- **Local LLM runtime:** llama.cpp
- **Speech-to-text:** whisper.cpp
- **Storage:** Markdown files, JSON metadata, and an optional SQLite index
- **iOS background execution:** BGTaskScheduler
- **Notifications:** local notifications via UNUserNotificationCenter


## Current Implementation

This repository now contains a runnable Flutter MVP shell for iOS-first testing:

- Calm home screen with text capture and a voice-capture placeholder.
- Local Markdown persistence for thoughts under the app support directory.
- Thought feed with lifecycle status updates.
- Local weekly-review generation and Markdown persistence.
- Unit tests for Markdown serialization, repository persistence, audio cleanup, and weekly-review generation.

See [`docs/iphone-testing.md`](docs/iphone-testing.md) for step-by-step instructions to run the app on your own iPhone.

## MVP Roadmap

1. Core capture: text input, Markdown storage, and feed view.
2. Voice: recording, whisper.cpp integration, transcription, and temporary audio cleanup.
3. Weekly review: local summarization and Markdown review generation.
4. Background tasks: precompute window, BGTaskScheduler integration, and local notifications.
5. Settings: review timing and AI processing modes.

See [`docs/mvp-v1-plan.md`](docs/mvp-v1-plan.md) for the detailed product and architecture plan.
