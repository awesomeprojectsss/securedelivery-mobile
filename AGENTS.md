# AGENTS.md — SecureDelivery Mobile IoT

## Purpose of This File

This file defines how AI coding agents must work inside the SecureDelivery Mobile repository.

The mobile technology stack has not been finalized.

Agents must not select or introduce a major mobile framework unless explicitly requested.

Read:

- the shared SecureDelivery `project.md`
- `docs/architecture.md`

before making architectural changes.

---

## Required Project Context

The SecureDelivery mobile application is the primary IoT device in the MVP.

The test smartphone will be mounted horizontally on a flat surface of the SmartBox.

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

## Agent Workflow

Before implementing changes:

1. Read this `AGENTS.md`.
2. Read `docs/architecture.md`.
3. Inspect existing framework and project conventions.
4. Do not choose a new framework unless explicitly asked.
5. Preserve separation between sensors, event detection, persistence, synchronization and UI.
6. Consider background execution limitations.
7. Consider battery impact.
8. Consider offline behavior.
9. Add or update meaningful tests.
10. Avoid unrelated refactors.
11. Update architecture documentation for architectural changes.
12. Create/update ADRs for meaningful architectural decisions.

---

## Architectural Decision Records

Document meaningful decisions under:

```text
docs/decisions/
```

Create or update ADRs when changes affect:

- mobile framework
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

## SmartBox Model

`SmartBox` is the logical delivery-box entity.

The smartphone is the MVP IoT device attached to the SmartBox.

Do not encode assumptions that every future SmartBox will always use a smartphone.

The mobile application should behave as one IoT device implementation.

---

## Physical Test Assumption

For MVP testing, the smartphone is mounted horizontally on a flat SmartBox surface.

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

Represent monitoring state explicitly.

Do not infer critical lifecycle state only from UI state.

---

## Sensor Sampling

Initial MVP target:

```text
1 sample per second
```

Sensor sampling should be isolated behind abstractions.

Do not access hardware sensors directly from arbitrary UI components.

Potential abstractions include:

- MotionSensorProvider
- LocationProvider
- BatteryProvider
- ConnectivityProvider
- SensorCollector
- EventDetectionEngine
- TelemetryStore
- SyncEngine

Names may differ.

Separation of responsibilities matters more than exact names.

---

## Event Detection

Event detection happens on-device.

Initial event types may include:

```text
STRONG_IMPACT
CRITICAL_INCLINATION
POSSIBLE_FALL
ABNORMAL_MOVEMENT
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

## Event Evidence

Every event must retain the evidence that triggered it.

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

Initial strategy:

```text
sensor sampling: every 1 second
telemetry batching: every 1 minute
```

The app should:

1. collect
2. persist locally
3. create logical batches
4. attempt synchronization
5. retain data when transmission fails
6. retry later
7. mark data synchronized only after reliable server acknowledgement

---

## Idempotency

The mobile app must generate stable unique identifiers before transmission.

Examples:

```text
telemetryBatchId
eventId
```

Retries must reuse the same logical identifiers.

Do not generate a new identifier for every retry of the same logical payload.

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

The selected framework must eventually support the required platform behavior.

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

The mobile app exposes the SmartBox activation QR Code in the MVP.

The QR Code should represent a secure activation flow, not merely a raw SmartBox database ID.

The exact token and deep-link strategy should be coordinated with the backend architecture.

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
- SmartBox identity/activation state

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

Use TypeScript if the selected framework supports it and the team confirms that choice.

Do not choose technology by assumption.

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
