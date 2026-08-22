# SecureDelivery Mobile IoT Architecture

## 1. Purpose

The SecureDelivery Mobile application acts as the primary IoT device during the MVP.

The mobile technology stack has not yet been selected.

This document defines responsibilities, boundaries and required behavior without prematurely selecting a framework.

---

## 2. Physical MVP Model

The smartphone is mounted horizontally on a flat surface of the SmartBox during tests.

This provides a known reference orientation that allows the MVP to test:

- inclination
- angular changes
- acceleration
- impact
- possible falls
- abnormal cargo movement

The mobile application represents one IoT-device implementation.

Future SmartBoxes may use dedicated hardware.

---

## 3. Responsibilities

The mobile application owns:

- monitoring lifecycle
- sensor access
- GPS access
- battery state
- connectivity state
- local event detection
- event evidence
- local durable storage
- telemetry batching
- store-and-forward
- retry
- synchronization
- QR Code activation presentation

The mobile application does not own persistent server-side business truth.

---

## 4. High-Level Architecture

```text
┌───────────────────────────┐
│ Presentation / Controls   │
│                           │
│ Monitoring ON/OFF         │
│ Sync State                │
│ Battery                   │
│ Connectivity              │
│ Activation QR             │
└─────────────┬─────────────┘
              │
              ▼
┌───────────────────────────┐
│ Monitoring Coordinator    │
└───────┬─────────┬─────────┘
        │         │
        ▼         ▼
 Sensor Layer   Device State
        │
        ▼
 Event Detection Engine
        │
        ├───────────────┐
        ▼               ▼
 Telemetry Store     Event Store
        │               │
        └───────┬───────┘
                ▼
            Sync Engine
                │
                ▼
      SecureDelivery Server
```

Exact components depend on the selected framework.

---

## 5. Monitoring Lifecycle

Minimum states:

```text
MONITORING_OFF
MONITORING_ON
```

Additional internal states may be introduced when needed.

Monitoring should not be represented only by whether a UI toggle is checked.

The monitoring coordinator owns actual monitoring state.

---

## 6. Sensor Layer

The sensor layer should abstract platform-specific APIs.

Possible capabilities:

- accelerometer
- gyroscope
- GPS
- battery
- connectivity

Consumers should not depend directly on low-level platform APIs.

This supports:

- testing
- future framework changes
- calibration
- dedicated IoT-device evolution

---

## 7. Sampling Strategy

Initial target:

```text
1 sample per second
```

Sampling frequency and network transmission frequency are separate concerns.

The architecture must not equate "1 Hz sensor sampling" with "1 network request per second".

---

## 8. Event Detection Engine

Event detection runs locally.

Initial event categories:

```text
STRONG_IMPACT
CRITICAL_INCLINATION
POSSIBLE_FALL
ABNORMAL_MOVEMENT
```

The engine receives sensor samples and produces deterministic event decisions plus evidence.

Thresholds and formulas are expected to evolve through physical testing.

Configuration should remain centralized.

---

## 9. Event Evidence

Detected events require evidence.

Conceptual structure:

```text
DetectedEvent
 ├── eventId
 ├── type
 ├── occurredAt
 ├── location
 ├── calculatedValues
 └── evidenceSamples[]
```

Evidence should be durable until successful server synchronization and retention policy allows cleanup.

---

## 10. Local Storage

Local persistence is required for correctness.

The exact storage technology is undecided.

Requirements:

- durable telemetry storage
- durable event storage
- durable sync state
- stable IDs
- timestamp preservation
- query of unsynchronized data
- safe cleanup after acknowledgement

In-memory-only buffering is insufficient.

---

## 11. Telemetry Batching

Initial MVP strategy:

```text
Sensor sampling: 1 second
Batch interval: 1 minute
```

Conceptual:

```text
60 approximate samples
        ↓
TelemetryBatch
        ↓
Local persistence
        ↓
Sync attempt
```

The exact number of samples may vary due to mobile scheduling and platform limitations.

Do not assume perfect one-second scheduling.

---

## 12. Store-and-Forward

```text
Collect
  ↓
Persist
  ↓
Batch
  ↓
Try Sync
  ↓
Success? ── yes ──> Mark acknowledged / cleanup when safe
  │
  no
  ↓
Keep local
  ↓
Retry after connectivity returns or retry policy allows
```

The synchronization strategy must tolerate repeated app restarts.

---

## 13. Idempotency

The mobile application generates identifiers before synchronization.

At minimum:

```text
telemetryBatchId
eventId
```

A retry reuses the same ID.

This allows the backend to safely deduplicate.

---

## 14. Background Execution

Background monitoring is a required capability, but the exact implementation depends on the selected framework and operating systems.

The architecture must eventually account for:

- Android foreground/background service rules
- iOS background restrictions
- background location permission
- sensor availability
- process suspension
- battery optimization

This is an unresolved implementation area and should become an ADR when the mobile stack is selected.

---

## 15. Battery

Battery state is monitored and sent to the server.

The architecture should avoid unnecessary energy use.

Sampling, GPS and sync policies should be configurable.

---

## 16. Connectivity

Connectivity state should influence synchronization.

The app should not aggressively retry when offline.

A controlled retry strategy should be implemented.

---

## 17. Location

The mobile application provides:

- latest known location
- event-associated location

Full route collection is outside the MVP.

Do not add continuous high-frequency route tracking without a new architectural/product decision.

---

## 18. SmartBox Activation

The mobile app exposes a QR Code used to activate the SmartBox.

Conceptually:

```text
Mobile receives activation material
        ↓
QR Code displayed
        ↓
Customer scans
        ↓
Server validates token
        ↓
SmartBox activated
```

The final deep-link, token and authentication flow must be coordinated with the backend.

---

## 19. Networking

The transport is not fully finalized.

Possible approaches include:

- HTTPS
- MQTT

The architecture should keep the sync engine independent from sensor collection and event detection.

Transport choice should become an ADR when decided.

---

## 20. Security

Requirements include:

- secure credential storage
- authenticated requests
- secure activation material
- no plaintext secret storage
- minimal sensitive logging

The exact secure-storage mechanism depends on the selected framework/platform.

---

## 21. Testing Strategy

Core algorithms should run without real hardware in automated tests.

Prioritize testability of:

- event detection
- angle calculations
- acceleration processing
- evidence capture
- batching
- retry
- store-and-forward
- state transitions

Platform sensor integrations should be abstracted and mockable.

---

## 22. Open Architectural Decisions

Still to be defined:

- mobile framework
- target platforms
- local database/storage
- background execution strategy
- transport protocol
- secure storage solution
- sensor API libraries
- QR/deep-link implementation
- exact event detection formulas
- calibration strategy
