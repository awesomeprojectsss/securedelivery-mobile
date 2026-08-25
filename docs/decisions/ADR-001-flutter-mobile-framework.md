# ADR-001: Flutter as the Mobile Framework

## Status

Accepted

## Context

The SecureDelivery MVP requires a mobile application that acts as the primary IoT device.

The application must access smartphone sensors, GPS, battery and connectivity state, operate in the background where the operating system allows it, persist telemetry locally and implement store-and-forward synchronization.

A mobile framework decision is required so implementation can begin with a stable technology baseline.

## Decision

Use **Flutter** as the SecureDelivery mobile application framework.

Use **Dart** as the application language.

Flutter-specific plugins and platform integrations should be isolated behind application interfaces where practical so event detection, persistence and synchronization logic remain testable independently from device APIs.

## Consequences

- Mobile application code is written in Dart.
- Flutter becomes the baseline for Android/iOS application development.
- Sensor, background execution, storage and networking packages must be compatible with Flutter and the target operating systems.
- Platform-specific limitations must still be handled explicitly.
- State management, local persistence, background execution plugins and transport libraries remain separate architectural decisions.
- Replacing Flutter requires a new ADR that supersedes this decision.
