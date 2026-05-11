# Braindump App — Product & Architecture Plan (MVP v1)

## Vision

Braindump is a local-first app for capturing unfiltered thoughts by text or voice. The app processes user data primarily on-device and automatically creates one compact weekly reflection with:

- Summary
- Patterns
- Connections
- Open topics
- Possible next steps
- Optional drop recommendations

Privacy and mental calm are core to the product. The MVP does not require cloud services, accounts, persistent analysis, gamification, social features, or productivity-driven UX.

## Product Principles

### 1. Privacy First

- All user data is local by default.
- No accounts are required.
- No mandatory cloud dependency exists.
- No telemetry is included in the MVP.
- No external AI call is used in the MVP.

### 2. Frictionless Capture

Thoughts must be extremely fast to capture:

- One tap for text capture.
- One tap for voice capture.
- No folders are required.
- No structure is required before saving.

### 3. Calm Technology

The app should:

- Feel quiet and unobtrusive.
- Avoid constant analysis.
- Avoid frequent push notifications.
- Deliver only relevant weekly reflections.

### 4. User Ownership

The user's data belongs to the user:

- Entries are stored as Markdown files.
- Metadata uses open, readable structures.
- Data is exportable.
- The app avoids vendor lock-in.

## MVP Scope

### Included Features

#### Thought Capture

- Text input.
- Voice input.
- Local storage.

#### Local Transcription

- Speech-to-text processing runs locally.
- Raw audio is automatically deleted after successful transcription and Markdown entry creation.
- Long-term raw audio storage is not part of the MVP.

#### Weekly Review

The app automatically creates a weekly summary covering:

- Themes.
- Patterns.
- Connections.
- Next steps.
- Drop suggestions.

#### Local Notifications

The app sends one weekly local notification:

> Dein Wochenreview ist bereit.

#### Thought Lifecycle

Each thought can have one of these statuses:

- `active`
- `done`
- `dropped`
- `archived`

### Explicitly Out of Scope

- Cloud sync.
- Multi-device sync.
- AI chat.
- Embeddings search.
- Semantic search.
- Daily reviews.
- Social features.
- Collaboration.
- Online accounts.

## Platform

### MVP Target Platform

The MVP targets iOS first.

### Later Platforms

- Android.
- Desktop.

## Tech Stack

### Frontend

Flutter is the planned frontend framework because it offers good local performance, later Android support, offline-friendly app development, and background-task integration options.

### Local LLM Runtime

The app uses `llama.cpp` for local model inference.

### Speech-to-Text

The app uses `whisper.cpp` for local transcription.

### Storage

The storage model is based on:

- Markdown files.
- JSON metadata.
- Optional SQLite index.

## Project Structure

```text
/app
  /lib
  /native
  /services
  /models
  /ui

/data
  /entries
  /reviews
  /metadata
  /audio_temp
  /models
```

## Data Structure

### Thought Entry

Example file path:

```text
entries/2026-05-07T0815.md
```

Example content:

```markdown
---
id: 4fd2b
created_at: 2026-05-07T08:15:22
source: voice
status: active
tags:
  - work
  - frustration
---

Heute wieder extrem mühsames Meeting.
Keine klaren Entscheidungen.
Denke immer öfter über Wechsel nach.
```

## Status Model

Allowed statuses:

```text
active
done
dropped
archived
```

## Weekly Review Format

Example file path:

```text
reviews/2026-week-19.md
```

Example content:

```markdown
# Weekly Review

## Main Themes
- Frustration about unclear decisions
- Running motivation fluctuating
- Entrepreneurial ideas increasing

## Recurring Patterns
- Work topics consume mental energy
- Creative thoughts often occur after training

## Open Loops
- Considering job change
- Product idea not yet validated

## Suggested Next Steps
- Prepare discussion about responsibilities
- Validate drink concept with 3 people

## Suggested Drops
- Old meeting frustration topic appears inactive
```

## Audio Handling

### Recording Flow

1. The user taps the microphone.
2. Recording starts.
3. The user stops recording.
4. Local transcription starts.
5. A Markdown entry is generated.
6. Raw audio is automatically deleted.

### Audio Storage

Audio is stored only temporarily in:

```text
/audio_temp
```

The MVP does not permanently archive raw audio.

## AI Architecture

### Design Philosophy

AI should:

- Summarize.
- Connect patterns.
- Identify repetition.
- Stay unobtrusive.

AI should not:

- Interrupt constantly.
- Behave like a coach.
- Over-analyze.
- Gamify usage.

### Local Models

#### Fast Tasks

Small models are used for tagging and classification. Candidate model families include:

- Phi 3 Mini.
- Gemma 2B.
- Qwen small.

#### Weekly Review

A larger quantized 3B–7B model is acceptable for weekly reviews because the workload runs only weekly and higher latency is acceptable.

## Weekly Review Pipeline

### Trigger

The default user-configured review time is:

```text
Thursday 17:00
```

### Required Strategy: Precompute Window

The review is not computed exactly at the notification time. Instead, the app performs an earlier background precomputation, saves the result, and then shows the notification when the finished review is ready.

### Flow

Between approximately 16:00 and 17:00, when the operating system allows background execution, the app:

1. Loads all active thoughts from the last seven days.
2. Ignores dropped thoughts.
3. Groups topics.
4. Starts local summarization.
5. Creates a weekly review Markdown file.
6. Saves the result locally.
7. Schedules a local push notification.

At 17:00, the local notification says:

> Dein Wochenreview ist bereit.

This avoids making the user wait for generation after tapping the notification.

## iOS Background Execution

The MVP uses `BGTaskScheduler`. iOS decides actual background execution timing, so the system must be robust when execution happens earlier or later than requested. This makes the precompute strategy mandatory.

## Notification System

Only local notifications are used. No server is required. The planned iOS API is `UNUserNotificationCenter`.

## UI/UX

### Home Screen

The home screen is intentionally minimal and focused on two primary actions:

1. Write a thought.
2. Speak a thought.

### Thoughts Feed

The feed is a simple chronological list without complex folders. Optional filters may include:

- Status.
- Tags.

### Weekly Review Screen

The weekly review screen is compact and calm, with these sections:

- Main Themes.
- Patterns.
- Open Loops.
- Suggested Next Steps.
- Suggested Drops.

The MVP should avoid dashboards.

### Settings

MVP settings include:

- Review timing, with `Thursday 17:00` as the default.
- AI processing mode: `fast`, `balanced`, or `deep review`.

## Local File Philosophy

Markdown files are the source of truth because they are:

- Human-readable.
- Portable.
- Future-proof.
- Editable outside the app.

## Future Version Ideas

These ideas are not part of the MVP.

### Local Network Synchronization

Potential technologies:

- Wi-Fi peer-to-peer.
- Bluetooth metadata sync.
- Encrypted transfer.

### Sync Strategy

Synchronize only:

- Markdown files.
- Metadata.
- Reviews.

Do not synchronize raw audio files.

## Security

Future versions may add:

- Device encryption support.
- Optional app-level encryption.

## Performance Constraints

The app must run on modern iPhones without overheating or excessive battery usage. Weekly review generation may take one to five minutes and should be handled through background execution where possible.

## Suggested Development Phases

1. **Core Capture:** text input, Markdown storage, and feed view.
2. **Voice:** recording, `whisper.cpp` integration, and automatic audio deletion.
3. **Weekly Review:** local summarization and Markdown review generation.
4. **Background Tasks:** `BGTaskScheduler`, precompute window, and notifications.
5. **Settings:** review timing and AI modes.

## Core Product Identity

This app is not:

- A productivity app.
- A task manager.
- An AI assistant.

This app is:

- A mental unloading space.
- A reflection system.
- A calm weekly mirror for the user.
