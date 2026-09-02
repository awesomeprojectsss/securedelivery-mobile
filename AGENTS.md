# AGENTS.md — SecureDelivery Mobile IoT

## Purpose of This File

This file defines how AI coding agents must work inside the SecureDelivery Mobile repository.

The mobile technology baseline is:

- Flutter
- Dart

Flutter is an accepted architectural decision for the MVP.

Agents must not replace Flutter with another mobile framework unless explicitly requested and the architectural decision is updated through an ADR.

Read:

- `../docs/project.md`
- `docs/architecture.md`

before making architectural changes.

---

## Required Project Context

The SecureDelivery mobile application is the primary IoT device in the MVP.

The test smartphone will be mounted horizontally on a flat surface of the delivery box. The Flutter app is the MVP implementation of a technical `Device`; the Dashboard presents it as a SmartBox.

The application is not only a UI.

It is responsible for:

- sensor collection
- GPS collection
- battery monitoring
- connectivity monitoring
- event detection
- local durable persistence
- telemetry batching
- store-and-forward
- retry
- event evidence preservation
- background monitoring

Temperature monitoring is outside the MVP.

---

## Technology Baseline

The MVP mobile application uses:

- Flutter
- Dart

The specific choices for state management, local database, background execution plugins, sensor plugins, secure storage and networking packages are still architectural decisions to be made.

Prefer Flutter abstractions and platform channels/plugins behind explicit application interfaces so core event-detection and synchronization logic remains testable.

---

## Core Engineering Priorities

When tradeoffs exist, prioritize:

```text
data integrity
> event evidence
> reliability
> safe background behavior
> battery efficiency
> maintainability
> convenience features
```

Do not sacrifice correctness for realtime appearance.

---

## Shared Contract Policy

Before implementing or changing communication between repositories, read:

- `../docs/contracts/README.md`
- `../docs/contracts/openapi.yaml`
- `../docs/contracts/asyncapi.yaml` when realtime is involved
- relevant contract documentation under `../docs/contracts/`
- shared ADRs under `../docs/decisions/`

The contracts under `../docs/contracts/` are authoritative.

Do not invent, duplicate or silently modify cross-repository payloads.

When changing a shared contract:

1. update the canonical contract first;
2. evaluate backward compatibility;
3. update the server implementation;
4. regenerate/update typed clients when generation is configured;
5. update affected consumers;
6. update tests;
7. update architecture documentation and ADRs when required.

`Device` is the canonical technical term.

Do not use `SmartBox` in API paths, backend DTOs, persistence entities or cross-repository contract schemas.

`SmartBox` is a product-facing UI label only.

## Agent Workflow

Before implementing changes:

1. Read this `AGENTS.md`.
2. Read `docs/architecture.md`.
3. Inspect the existing Flutter project structure and repository conventions.
4. Follow established Flutter and Dart conventions already present in the repository.
5. Do not replace Flutter or introduce a second application framework without an explicit architectural decision.
6. Preserve separation between sensors, event detection, persistence, synchronization and UI.
7. Consider background execution limitations.
8. Consider battery impact.
9. Consider offline behavior.
10. Add or update meaningful tests.
11. Avoid unrelated refactors.
12. Update architecture documentation for architectural changes.
13. Create/update ADRs for meaningful architectural decisions.

---

## CI/CD Baseline

The repository currently calls the centralized documentation CI from `securedelivery-main`. Do not claim to analyze, test or build the Flutter application until it is initialized.

After bootstrap, extend the repository CI with the real `flutter pub get`, formatting/analyze and test commands adopted by the project. Keep GitHub Actions as the single pipeline platform, use read-only permissions by default and do not add deployment before environments, signing secrets, health checks and rollback/distribution procedures are decided.

---

## Architectural Decision Records

Document meaningful decisions under:

```text
docs/decisions/
```

Create or update ADRs when changes affect:

- replacement or major change of the Flutter framework baseline
- local persistence technology
- sensor abstraction
- event detection architecture
- background execution strategy
- sync protocol
- store-and-forward
- batching
- device identity
- retry strategy
- location strategy
- security storage
- monitoring lifecycle

Do not create ADRs for routine UI changes or minor refactors.

Do not silently override an accepted decision.

---

## Device Model

`Device` is the canonical technical entity.

The Flutter application is the MVP Device implementation.

`SmartBox` is only a product-facing Dashboard label.

Do not encode assumptions that future Devices will always be smartphones.

All cross-repository contracts use `deviceId` and `/devices` terminology.

## Physical Test Assumption

For MVP testing, the smartphone is mounted horizontally on a flat delivery-box surface.

This provides a known reference orientation for:

- inclination
- acceleration
- impact
- fall detection
- abnormal movement

Algorithms may use this assumption in the MVP, but the assumption should be explicit and configurable where practical.

Do not scatter physical calibration constants across the codebase.

---

## Monitoring Lifecycle

The application must support explicit monitoring control.

At minimum:

```text
MONITORING_OFF
MONITORING_ON
```

When monitoring is off, background monitoring should stop where possible.

When monitoring is on:

- sensors are sampled
- event detection runs
- data is persisted locally
- synchronization is scheduled
- connectivity is monitored

Before monitoring starts, generate and durably persist the canonical `monitoringSessionId`. Reuse it for idempotent session creation, telemetry, events, stop synchronization and every retry. Monitoring must not depend on obtaining a server-generated session ID.

Represent monitoring state explicitly.

Do not infer critical lifecycle state only from UI state.

---

## Sensor Sampling

Initial MVP acquisition profile:

```text
Raw IMU sampling:               50 Hz (~20 ms)
Event detection:                high-frequency local processing/windows
GPS / ground-speed sampling:    up to 1 Hz
Normal Server telemetry:        1-minute summary
Network telemetry batch:        normally every 1 minute
```

The rates must be centralized and configurable.

Raw IMU stays Device-local during normal operation.

Maintain a rolling high-frequency evidence buffer.

GPS/ground-speed observations are used locally to produce navigation summaries and event context.

Do not expose 50 Hz IMU data to general UI state.

Do not continuously synchronize raw motion data when no relevant event exists.

## Lean Telemetry Aggregation

At the end of each normal telemetry period, initially one minute, create a compact summary.

MVP structured navigation fields:

```text
navigation.distanceTraveledMeters
navigation.movingDurationSeconds
navigation.stoppedDurationSeconds
navigation.maximumSpeedMetersPerSecond
```

Telemetry schema version 3 also requires `navigation.status` and `navigation.source`. Keep every metric key present, use `null` for unavailable values and never synthesize zero. Follow the canonical VALID/PARTIAL/UNAVAILABLE invariants.

Use canonical SI units:

```text
distance -> m
duration -> s
speed    -> m/s
```

Preferred speed source is GNSS/operating-system ground speed.

Do not use integrated accelerometer acceleration as the normal speed source.

Initial configurable moving threshold:

```text
1.5 m/s (~5.4 km/h)
```

If GNSS speed is unavailable, a GPS-fix-based fallback may be used only with accuracy/time filtering.

Persist completed summaries durably for store-and-forward.

Old normal raw IMU samples may be discarded when they are outside the rolling evidence window and are not required by an event.

## Event Detection

Event detection happens on-device.

Initial event types may include:

```text
motion.strong_impact
motion.critical_inclination
motion.possible_fall
motion.abnormal_movement
```

The exact thresholds and algorithms are not fixed yet.

Keep detection logic:

- deterministic
- testable
- isolated
- configurable
- explainable

Do not introduce machine learning without explicit instruction.

---

## Event Speed Context

When reliable navigation data is available, motion events should include:

```text
navigation.speed.at_event
navigation.speed.average_5s_before
navigation.speed.maximum_10s_before
navigation.moving
```

Keep a small Device-side navigation context buffer to derive these values.

Do not fabricate speed context when GNSS quality is insufficient.

Speed is context for correlation and investigation, not automatic proof that speed caused an event.

## Extensible Device Protocol

The Mobile application owns raw-sensor interpretation.

New measurements must use the generic `Observation` contract:

```json
{
  "key": "motion.orientation.pitch",
  "value": 42.7,
  "unit": "deg"
}
```

New Device-generated events must use open namespaced `eventType` strings.

When adding a new sensor or detector:

- use the existing Observation envelope;
- use namespaced keys;
- preserve original timestamps;
- preserve event evidence;
- include detector name/version;
- do not request a backend contract change unless the common envelope itself is insufficient.

Do not couple Device evolution to server releases unnecessarily.

## Event Evidence

Every event must retain the evidence that triggered it.

Initial event evidence should target a configurable rolling window around the trigger:

```text
approximately 2 seconds before
+
trigger/event interval
+
approximately 2 seconds after
```

At the 50 Hz baseline, evidence captures samples roughly every 20 ms.

Evidence may include:

- accelerometer samples
- gyroscope samples
- calculated angles
- GPS
- timestamps
- relevant derived values

Do not discard raw evidence immediately after classification.

Evidence is important for:

- audit
- debugging
- calibration
- false-positive analysis

---

## Local Persistence

Offline-first behavior requires durable local storage.

Do not rely on in-memory buffers for telemetry or critical events.

The exact storage technology depends on the selected mobile stack and should be documented once chosen.

Data should be persisted before it is considered safe to send.

---

## Store-and-Forward

Normal server telemetry uses durable one-minute summaries.

Initial strategy:

```text
raw IMU:                 50 Hz, local rolling buffer
GPS / ground speed:      up to 1 Hz, local aggregation/context
normal telemetry:        1-minute summaries
network batch:           normally every 1 minute
event evidence:          high-frequency, only around relevant events
```

Rules:

1. complete the one-minute summary;
2. persist the summary durably;
3. create/reuse an idempotent batch;
4. attempt synchronization;
5. if synchronization fails, retain pending summaries;
6. when connectivity returns, send one or more accumulated summaries;
7. remove/mark synchronized data only after valid server acknowledgement.

Raw IMU samples that are not part of an event do not need durable long-term storage and may leave the rolling buffer when no longer relevant.

## Idempotency

The mobile app must generate stable unique identifiers before transmission.

Examples:

```text
monitoringSessionId
batchId
eventId
```

Retries must reuse the same logical identifiers.

Do not generate a new identifier for every retry of the same logical payload.

Persist the Device-observed `startedAt` and `finishedAt`. After reconnecting, reconcile session creation before dependent records and send the actual `finishedAt`, not synchronization time.

---

## Timestamps

Preserve original device timestamps.

Do not replace event time with sync time.

The app should distinguish:

- sample time
- event time
- batch creation time
- sync time

Use a consistent time representation.

---

## Connectivity

Connectivity is unreliable by design.

Handle:

- no internet
- poor mobile signal
- timeout
- backend unavailable
- app backgrounding
- retry after reconnect

Avoid aggressive retry loops.

Prefer controlled backoff and connectivity-aware sync.

---

## Background Execution

Monitoring is expected to run in background while enabled.

Do not assume unrestricted background execution.

The Flutter implementation must support the required platform behavior through appropriate Flutter/platform integrations.

Architecture must consider:

- Android background restrictions
- iOS background restrictions
- battery optimization
- app suspension
- background location rules
- background sensor availability

Do not silently pretend background monitoring is reliable if the platform prevents it.

---

## Battery

Battery monitoring is part of the MVP.

Avoid designs that unnecessarily drain the device.

Sensor sampling and GPS policies should remain centralized and configurable.

Do not run uncontrolled network retries.

---

## Location

The MVP does not implement complete route tracking.

Location is used for:

- latest known location
- event-associated location

Do not collect or persist more location data than the current product requires without an explicit decision.

---

## QR Activation

The mobile app exposes the Device activation QR Code in the MVP. The product UI may describe it as SmartBox activation.

The QR Code should represent a secure activation flow, not merely a raw Device database ID.

Use the canonical body-based activation endpoints. A web QR link may carry activation material in its URL fragment so it is read locally rather than sent in the HTTP request URL. Never place activation material in a path/query or write it to logs, traces or errors.

After Customer confirmation, exchange the short-lived activation material once for the Device bearer credential. Store it using secure operating-system storage. It is scoped to this Device and separate from human user authentication.

---

## Networking

The final mobile-to-server transport is not fully fixed.

HTTPS is a valid baseline.

MQTT remains discussable.

Do not tightly couple sensor collection and persistence to one transport implementation.

Networking should sit behind an abstraction so synchronization logic can remain stable.

---

## Security

Use secure operating-system storage for credentials when the stack is chosen.

Never store secrets or authentication tokens in plain text.

Do not log sensitive tokens.

Device identity should be controlled by SecureDelivery, not only by arbitrary OS hardware identifiers.

---

## UI

The application should require minimal interaction during monitoring.

Never design interactions that encourage phone usage while the courier is moving.

The user should clearly understand:

- monitoring on/off
- synchronization state
- connectivity
- battery
- important errors
- Device identity/activation state (presented as SmartBox to the user)

Do not expose raw sensor streams in normal operational UI unless useful for test/debug screens.

---

## Testing

Prioritize tests for:

- angle calculations
- impact calculations
- event detection
- threshold behavior
- event evidence
- telemetry batching
- local persistence
- retry
- store-and-forward
- idempotent identifiers
- monitoring state transitions
- synchronization state

Sensor providers should be mockable.

Algorithms should be testable without physical hardware.

---

## Development Standards

Use:

- Git
- GitHub
- Pull Requests
- Code Review
- Conventional Commits
- automated tests
- linting
- formatting

Use Dart as the application language.

Follow the repository's configured Dart analyzer, formatting and linting rules.

Prefer strong typing and null safety.

Avoid:

- unnecessary `dynamic`
- unsafe casts
- duplicated domain models
- scattered hardcoded thresholds
- direct platform-plugin access from presentation widgets

Do not replace Flutter or Dart by assumption.

---

## Conventional Commits Examples

```text
feat(sensors): add motion sampling
feat(events): detect critical inclination
feat(sync): add store-and-forward
feat(activation): display smartbox activation qr
fix(sync): reuse batch id after retry
fix(events): preserve evidence timestamps
test(events): cover fall detection thresholds
docs: document background monitoring constraints
```

---

## Technology Best Practices

Follow official Flutter and Dart conventions and established ecosystem best practices.

Prefer idiomatic Flutter solutions over patterns copied from React, web frameworks or backend architectures.

Before adding a custom abstraction, check whether Flutter, Dart or the selected platform package already solves the problem cleanly.

Keep the application testable even when platform plugins are involved.

---

## Flutter Engineering Guidelines

- Use Dart null safety consistently.
- Avoid unnecessary `dynamic`.
- Prefer immutable models and explicit state transitions.
- Keep widgets focused on presentation and user interaction.
- Do not access sensors, GPS, local storage, secure storage or networking directly from arbitrary UI widgets.
- Isolate platform plugins behind application interfaces.
- Keep event-detection logic independent from Flutter widgets.
- Keep synchronization logic independent from presentation code.
- Avoid large `StatefulWidget` classes containing application logic.
- Prefer composition over deep inheritance.
- Centralize sensor thresholds and calibration configuration.
- Do not scatter Android/iOS checks throughout feature code.
- Dispose streams, subscriptions, controllers and sensor listeners correctly.
- Avoid unnecessary widget rebuilds.
- Keep high-frequency sensor data out of general UI state when it does not need to trigger rendering.
- Respect app lifecycle transitions explicitly.
- Keep async error handling explicit.
- Do not ignore failures from local persistence or synchronization.
- Keep platform-channel/plugin code behind replaceable boundaries.
- Use `const` widgets where appropriate.
- Keep domain/event logic usable in pure Dart tests whenever possible.

---

## IoT and Background Processing Guidelines

Sensor collection, event detection, persistence and synchronization are separate concerns.

Preserve this conceptual pipeline:

```text
Sensors
  -> Collector
  -> Event Detection
  -> Local Persistence
  -> Batch / Sync Engine
  -> SecureDelivery API
```

Rules:

- Do not couple sensor callbacks directly to network requests.
- Do not require network connectivity for event detection.
- Persist critical events before considering them safe.
- Do not remove persisted telemetry/events until server acknowledgement confirms synchronization.
- Do not assume perfect 1-second scheduling in background execution.
- Preserve original timestamps even when transmission is delayed.
- Design retries so they do not unnecessarily drain the battery.
- Monitoring must recover safely after process/app restarts when supported by the chosen persistence/background strategy.

---

## Sensor and Event-Detection Guidelines

- Keep raw sensor acquisition separate from derived calculations.
- Keep angle, acceleration and impact calculations in testable pure Dart code where practical.
- Centralize calibration and threshold configuration.
- Preserve evidence samples that caused an event.
- Avoid classifying driving behavior when only cargo movement is relevant.
- Treat the horizontally mounted smartphone orientation as an explicit MVP calibration assumption.
- Do not silently hardcode orientation assumptions across multiple files.
- Prefer deterministic and explainable detection logic for the MVP.
- Validate changes against recorded/simulated sensor sequences whenever practical.

---

## Local Persistence Guidelines

- Use durable local persistence for unsynchronized telemetry and events.
- In-memory-only buffering is not sufficient.
- Persist stable IDs and synchronization state.
- Make local writes resilient to app interruption.
- Design cleanup only after server acknowledgement.
- Avoid holding large telemetry histories in memory.
- Use bounded queries/batches when reading pending telemetry.

---

## Testing Strategy

Prefer:

- pure Dart unit tests for event detection, angle calculations, acceleration processing and batching;
- tests using fake/mock sensor providers;
- tests for local persistence and recovery;
- tests for retry and store-and-forward behavior;
- widget tests for critical UI states and monitoring controls;
- integration tests for platform/plugin boundaries where practical.

High-value tests include:

- same batch ID reused after retry;
- event evidence preserved;
- monitoring state transition correctness;
- data retained after failed synchronization;
- synchronization recovery after connectivity restoration.

---

## Human Developer Documentation

Human developers should also read:

- `docs/development-guide.pt-BR.md`
- `docs/git-workflow.pt-BR.md`

These files define practical development conventions and the Git/GitHub workflow for the repository.

## Out of Scope for MVP

Do not implement unless explicitly requested:

- temperature sensor
- DS18B20
- ESP32 integration
- dedicated GNSS module
- Iridium
- satellite networking
- full route tracking
- route optimization
- machine learning
- advanced driver scoring
