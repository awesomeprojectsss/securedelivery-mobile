---
name: SecureDelivery Operational Interface
colors:
  surface: '#131315'
  surface-dim: '#131315'
  surface-bright: '#39393b'
  surface-container-lowest: '#0e0e10'
  surface-container-low: '#1b1b1d'
  surface-container: '#1f1f21'
  surface-container-high: '#2a2a2b'
  surface-container-highest: '#353436'
  on-surface: '#e4e2e4'
  on-surface-variant: '#c6c6cd'
  inverse-surface: '#e4e2e4'
  inverse-on-surface: '#303032'
  outline: '#909097'
  outline-variant: '#45464d'
  surface-tint: '#bec6e0'
  primary: '#bec6e0'
  on-primary: '#283044'
  primary-container: '#0f172a'
  on-primary-container: '#798098'
  inverse-primary: '#565e74'
  secondary: '#44e2cd'
  on-secondary: '#003731'
  secondary-container: '#03c6b2'
  on-secondary-container: '#004d44'
  tertiary: '#dec29a'
  on-tertiary: '#3e2d11'
  tertiary-container: '#231500'
  on-tertiary-container: '#957d5a'
  error: '#ef4444'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#62fae3'
  secondary-fixed-dim: '#3cddc7'
  on-secondary-fixed: '#00201c'
  on-secondary-fixed-variant: '#005047'
  tertiary-fixed: '#fcdeb5'
  tertiary-fixed-dim: '#dec29a'
  on-tertiary-fixed: '#271901'
  on-tertiary-fixed-variant: '#574425'
  background: '#131315'
  on-background: '#e4e2e4'
  surface-variant: '#353436'
  success: '#22c55e'
  warning: '#f59e0b'
  surface-dark: '#1e293b'
  border-muted: '#334155'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.02em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: '400'
    lineHeight: 18px
  label-caps:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.08em
  status-lg:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 24px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  margin-mobile: 1rem
  gutter-mobile: 0.75rem
  safe-area-bottom: 2.5rem
  stack-sm: 0.5rem
  stack-md: 1rem
  stack-lg: 1.5rem
---

## Brand & Style

This design system is engineered for high-stakes operational oversight in the B2B IoT logistics sector. It prioritizes **Corporate / Modern** aesthetics, balancing the rigorous demands of enterprise data density with a clean, functional layout. The visual narrative is built on "Confidence through Clarity," utilizing a restrained color palette and systematic spacing to reduce cognitive load for field operators and logistics managers.

The interface must evoke a sense of reliability and technical precision, strictly avoiding "consumer delivery" tropes like playful illustrations or soft, bubbly UI. Instead, it leans into a "Dashboard as a Tool" philosophy where every pixel serves a functional purpose.

**Key Design Principles:**
- **Information Density:** High-density layouts that maximize "at-a-glance" telemetry data.
- **Visual Discipline:** Use of strict alignment and subtle borders rather than shadows or decorative flourishes.
- **Operational Readiness:** Large interactive targets and high-contrast status signaling for outdoor or high-glare environments.

## Colors

The palette is optimized for both professional Light and high-focus Dark modes. The default mode is **Dark**, as it reduces eye strain during prolonged monitoring and creates a high-contrast environment for IoT status indicators.

- **Primary (Deep Navy):** Represents the foundation of the system. Used for backgrounds in dark mode and primary navigation elements.
- **Accent (Teal/Turquoise):** Reserved for "Commit" actions, active sensor states, and critical path highlights.
- **Semantic Palette:** Green, Amber, and Red are strictly utility-bound for Success, Warning, and Error states respectively. These must never be used for decorative accents.
- **Neutral Grays:** Derived from the navy base (Slate) to maintain a cohesive cool-toned temperature across the interface.

## Typography

**Inter** is the workhorse of the design system, selected for its exceptional legibility in dense data environments. The type scale is designed to be compact yet hierarchical.

- **Headline LG:** Reserved for page titles and critical status numbers.
- **Label Caps:** Used for technical metadata and table headers, always in uppercase to differentiate from body content.
- **Status LG:** Specifically designed for large card values (e.g., Temperature, Speed, Signal Strength) where readability from a distance is required.
- **Body SM:** The standard size for data tables and secondary metadata to maintain high information density on mobile screens.

## Layout & Spacing

The design system follows a **mobile-first fluid grid** strategy. While the structure adapts to tablet and desktop, the core logic is built for handheld operational use.

- **Grid:** A 4-column fluid grid on mobile with 16px margins. On tablet, this expands to 8 columns.
- **Rhythm:** An 8px linear scale is used for all layout offsets, with a 4px half-step for micro-adjustments in technical labels.
- **Safe Areas:** Bottom navigation is heightened to account for system gestures, ensuring touch targets for Home, Events, and Settings are easily accessible during one-handed use.

## Elevation & Depth

This design system uses **Tonal Layers** and **Low-contrast Outlines** instead of traditional shadows to maintain a clean, technical look.

- **Layer 0 (Background):** Primary Navy (#0F172A).
- **Layer 1 (Cards/Containers):** Surface-dark (#1E293B) with a subtle 1px Slate border (#334155). This creates a "recessed" or "inset" feel common in professional dashboard design.
- **Layer 2 (Overlays/Modals):** High-contrast surface with a slight elevation using a tinted shadow (Primary Navy at 40% opacity, 12px blur) to separate temporary actions from the telemetry background.
- **Interactive Depth:** No neomorphic effects. Interactivity is communicated through fill changes and border color shifts (e.g., from Slate to Teal).

## Shapes

The shape language is **Soft (0.25rem)**. This provides a professional, "machined" aesthetic that feels modern but remains grounded and utilitarian. 

- **Base Radius (4px):** Used for buttons, inputs, and list items.
- **Large Radius (8px):** Reserved for primary status cards and modal containers.
- **Zero Radius:** Strictly used for full-width components (like header bars or bottom nav) that bleed into the edge of the screen.

## Components

**Status Cards:**
The centerpiece of the operational view. These are large-format containers with a top-weighted "Label Caps" heading, a central "Status LG" value, and a bottom-aligned status indicator (e.g., a Teal signal icon or Green "Optimal" tag).

**Action Buttons:**
- **Primary:** Solid Teal (#2DD4BF) with Navy text for maximum visibility. These are used for "Start/Stop" operations.
- **Confirmation State:** When a critical action is triggered, the button shifts to a 2-second "Hold to Confirm" state or a secondary toggle to prevent accidental taps.

**Iconography:**
Simple, thin-stroke (2px) icons for Sensors, Location, and Connectivity. Icons should be monochrome (Slate) unless they are actively signaling a status change (e.g., a Red "Disconnected" icon).

**Bottom Navigation:**
A minimal, fixed-height bar (64px) with high-contrast active states. Icons only for mobile, with 10px labels for tablet+ viewports.

**Input Fields:**
High-density inputs with internal labels. In dark mode, these use a darker-than-surface background with a persistent Slate border that glows Teal on focus.