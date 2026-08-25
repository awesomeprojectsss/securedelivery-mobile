# SecureDelivery Mobile IoT Architecture

## 1. Purpose

The SecureDelivery Mobile application acts as the primary IoT device during the MVP.

The mobile application uses Flutter with Dart.

This document defines the architectural responsibilities and boundaries of the Flutter application while leaving lower-level technology choices open where the team has not yet made a decision.

---

## 2. Physical MVP Model

The smartphone is mounted horizontally on a flat surface of the delivery box during tests.

This provides a known reference orientation that allows the MVP to test:

- inclination
- angular changes
- acceleration
- impact
- possible falls
- abnormal cargo movement

The mobile application represents one IoT-device implementation.

The Flutter application is the MVP implementation of the technical `Device`. `SmartBox` is the product-facing Dashboard label. Future Devices may use dedicated hardware.

---

## 3. Technology Baseline

The mobile MVP uses:

- Flutter
- Dart

Flutter is the accepted application framework.

Dart is the application language.

The architecture should preserve Flutter-specific platform integrations behind explicit abstractions so that sensor collection, event detection, persistence and synchronization remain independently testable.

The following choices are still open:

- state management
- local durable database/storage
- background execution plugins
- sensor plugins
- GPS/location plugin
- secure storage
- networking package
- WebSocket/MQTT support if adopted
- dependency injection approach
- test/mocking libraries

These decisions should be recorded through ADRs when selected.

---

## Engineering Practice Boundary

This architecture document defines SecureDelivery-specific boundaries and decisions.

Framework-level implementation guidance is defined in the repository `AGENTS.md`.

Human developers should also follow:

- `docs/development-guide.pt-BR.md`
- `docs/git-workflow.pt-BR.md`

Implementations should remain idiomatic to Flutter and Dart and should prefer official/framework-native solutions over unnecessary custom abstractions.


## 4. Responsibilities

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
- Device QR Code activation presentation

The mobile application does not own persistent server-side business truth.

---

## 5. High-Level Architecture

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

Exact components and Flutter packages depend on later architectural decisions.

---

## 6. Monitoring Lifecycle

Minimum states:

```text
MONITORING_OFF
MONITORING_ON
```

Additional internal states may be introduced when needed.

Monitoring should not be represented only by whether a UI toggle is checked.

The monitoring coordinator owns actual monitoring state.

---

## 7. Sensor Layer

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
- future replacement of platform plugins or device implementations
- calibration
- dedicated IoT-device evolution

---

## 8. Sampling Strategy

Acquisition and transmission frequencies are independent.

Initial MVP profile:

```text
Raw IMU:                       50 Hz (~20 ms)
Event detection:               high-frequency local processing
GPS / ground speed:            up to 1 Hz
normal Server telemetry:       one-minute summary
network batch:                 normally every minute
event evidence:                high-frequency window
```

The 50 Hz IMU data feeds:

- event detection;
- rolling evidence buffering.

GPS/speed samples feed:

- minute navigation aggregation;
- latest location;
- speed context for events.

The complete normal raw motion stream is not synchronized.

Rates and quality thresholds are configurable and must be calibrated using real-device testing.

## Navigation and Speed Processing

Preferred speed source:

```text
GNSS / operating-system ground speed
```

GPS/speed sampling target:

```text
up to 1 Hz
```

Do not derive normal delivery speed by integrating accelerometer data.

If direct ground speed is unavailable, a consecutive-GPS-fix fallback may be used only with explicit quality filtering.

Initial configurable movement threshold:

```text
1.5 m/s (~5.4 km/h)
```

For every one-minute summary, compute at least:

```text
distance traveled
moving duration
stopped duration
maximum speed
```

Maintain a short navigation context buffer so motion events can add, when reliable:

```text
speed at event
average speed in the previous 5 seconds
maximum speed in the previous 10 seconds
moving flag
```

GPS quality failures must produce missing/unknown context rather than fabricated values.

## 9. Event Detection Engine

Event detection runs locally.

Initial Device-generated event types:

```text
motion.strong_impact
motion.critical_inclination
motion.possible_fall
motion.abnormal_movement
```

The engine receives sensor samples and produces deterministic event decisions plus evidence.

Thresholds and formulas are expected to evolve through physical testing.

Configuration should remain centralized.

---

## 10. Event Evidence

Detected events require evidence.

Conceptual structure:

```text
DetectedEvent
 ├── eventId
 ├── eventType
 ├── occurredAt
 ├── location
 ├── detectorName
 ├── detectorVersion
 ├── calculatedValues
 └── evidenceSamples[]
```

Evidence should be durable until successful server synchronization and retention policy allows cleanup.

---

## Extensible Device Contract

Cross-repository payloads follow `../../docs/contracts/`.

The Mobile application sends generic sensor observations:

```text
namespaced key + typed value + optional unit
```

It sends Device-generated events through a stable generic envelope with an open namespaced `eventType`.

The Device must be able to introduce new sensors and detectors without requiring server DTO changes when the common envelope remains sufficient.

The detector implementation and version are part of event audit metadata.

## 11. Local Storage

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

## 12. Telemetry Batching

The Device aggregates normal operational telemetry into one-minute period summaries.

Each summary may contain:

- Device state;
- latest valid location;
- `navigation.distance.traveled`;
- `navigation.moving.duration`;
- `navigation.stopped.duration`;
- `navigation.speed.maximum`;
- future generic business-value observations.

Completed summaries are persisted locally before synchronization.

An online Device normally sends one period per batch.

An offline Device may accumulate multiple summaries and send them later in one batch.

Raw 50 Hz motion samples are not part of normal telemetry batching.

## 13. Store-and-Forward

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

## 14. Idempotency

The mobile application generates identifiers before synchronization.

At minimum:

```text
batchId
eventId
```

A retry reuses the same ID.

This allows the backend to safely deduplicate.

---

## 15. Background Execution

Background monitoring is a required capability. Its exact implementation depends on Flutter-compatible platform integrations and operating-system constraints.

The architecture must eventually account for:

- Android foreground/background service rules
- iOS background restrictions
- background location permission
- sensor availability
- process suspension
- battery optimization

This is an unresolved implementation area and should become an ADR when the mobile stack is selected.

---

## 16. Battery

Battery state is monitored and sent to the server.

The architecture should avoid unnecessary energy use.

Sampling, GPS and sync policies should be configurable.

---

## 17. Connectivity

Connectivity state should influence synchronization.

The app should not aggressively retry when offline.

A controlled retry strategy should be implemented.

---

## 18. Location

The mobile application provides:

- latest known location
- event-associated location

Full route collection is outside the MVP.

Do not add continuous high-frequency route tracking without a new architectural/product decision.

---

## 19. Device Activation

The mobile app exposes a QR Code used to activate the Device.

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
Device activated
```

The final deep-link, token and authentication flow must be coordinated with the backend.

---

## 20. Networking

The transport is not fully finalized.

Possible approaches include:

- HTTPS
- MQTT

The architecture should keep the sync engine independent from sensor collection and event detection.

Transport choice should become an ADR when decided.

---

## 21. Security

Requirements include:

- secure credential storage
- authenticated requests
- secure activation material
- no plaintext secret storage
- minimal sensitive logging

The exact secure-storage mechanism depends on the selected Flutter secure-storage approach and target platform.

---

## 22. Testing Strategy

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

## 23. Open Architectural Decisions

Still to be defined:

- target platforms
- Flutter state-management approach
- local database/storage
- background execution strategy and Flutter plugins
- transport protocol
- secure storage solution
- sensor API libraries
- QR/deep-link implementation
- exact event detection formulas
- calibration strategy

## Shared Integration References

Cross-repository behavior is defined in:

- `../../docs/contracts/domain-model.md`
- `../../docs/contracts/integration-flows.md`
- `../../docs/contracts/kpis.md`
- `../../docs/contracts/openapi.yaml`
- `../../docs/contracts/asyncapi.yaml`
