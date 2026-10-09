# Apple Human Interface Guidelines — Design Style Reference

```yaml
# How this file was made. Sources are first-party; nothing here is
# read from a rendered page. Full breakdown at source_page below.
method: restated-from-official-docs
confidence: high
verified_at: 2026-09-03
source_page: https://www.designsystems.one/design-systems/apple-hig
sources:
  - https://developer.apple.com/design/human-interface-guidelines/
  - https://developer.apple.com/design/human-interface-guidelines/color
  - https://developer.apple.com/design/human-interface-guidelines/typography
  - https://www.figma.com/@apple
```

> **Unofficial, community-authored reference.** Compiled by [designsystems.one](https://www.designsystems.one). Not affiliated with, endorsed by, or sponsored by Apple. "Apple Human Interface Guidelines" and related marks belong to their respective owners. This document describes publicly observable style attributes in original words — it contains no copied documentation, logos, icon artwork, or original token files. Always defer to the official source for canonical, current values.

**System:** Apple Human Interface Guidelines
**Owner:** Apple
**Official documentation:** https://developer.apple.com/design/human-interface-guidelines/
**Visual character:** The platform vernacular itself: San Francisco type, translucent materials, continuous corners, and physics-true motion everyone imitates.

---

## Summary

The platform conventions every Apple-shaped product is measured against.

_Editorial confidence: high. Values are drawn from well-documented public token references. Field-level evidence: 0/85 claims source-linked, 0/85 dated. Confidence is not verification; validate canonical values before implementation._

[Inspect every field and its evidence](https://www.designsystems.one/api/style-spec?system=apple-hig)

## Color tokens

| Color | Value | CSS variable | Role |
| --- | --- | --- | --- |
| System Blue | `#007aff` | `--apple-system-blue` | Default tint — links, buttons, selection (iOS light) |
| Label | `#000000` | `--apple-label` | Primary text (light mode) |
| Secondary Label | `#8e8e93` | `--apple-secondary-label` | Secondary text (systemGray) |
| System Background | `#ffffff` | `--apple-system-background` | Primary background |
| Secondary Background | `#f2f2f7` | `--apple-secondary-background` | Grouped background |
| Separator | `#c6c6c8` | `--apple-separator` | Hairline separators |
| System Red | `#ff3b30` | `--apple-system-red` | Destructive actions |
| System Green | `#34c759` | `--apple-system-green` | Success |
| System Orange | `#ff9500` | `--apple-system-orange` | Warnings |

## Typography

- **Display:** SF Pro Display — weights 400, 600, 700 — `-apple-system, 'SF Pro Display', 'Helvetica Neue', sans-serif`
- **Body:** SF Pro Text — weights 400, 600 — `-apple-system, 'SF Pro Text', 'Helvetica Neue', sans-serif`
- **Mono:** SF Mono — weights 400 — `'SF Mono', ui-monospace, Menlo, monospace`

## Type scale

| Step | Size | Line height |
| --- | --- | --- |
| large-title | `34px` | `41px` |
| title-1 | `28px` | `34px` |
| title-2 | `22px` | `28px` |
| headline | `17px` | `22px` |
| body | `17px` | `22px` |
| footnote | `13px` | `18px` |

## Spacing

Base unit: `8px (layout margins 16/20)`

Scale: `4px` · `8px` · `16px` · `20px` · `32px`

## Corner radius

| Name | Value |
| --- | --- |
| controls | `8px` |
| cards/sheets | `10px` |
| continuous-large | `20px` |

## Elevation / shadows

| Name | Value |
| --- | --- |
| subtle | `0 2px 10px rgba(0,0,0,0.1)` |

## Motion

| Name | Value |
| --- | --- |
| standard | `300ms ease-in-out` |
| spring | `spring(mass 1, stiffness 100, damping 15)` |

## Quick start (CSS)

```css
/* Apple Human Interface Guidelines — illustrative tokens, restated as CSS custom properties.
   Unofficial reference by designsystems.one; values are indicative, not
   canonical. Native dp/sp values are omitted, never silently converted.
   Official reference: https://developer.apple.com/design/human-interface-guidelines/
   Field evidence: https://www.designsystems.one/api/style-spec?system=apple-hig */

:root {
  /* Color */
  --apple-system-blue: #007aff; /* Default tint — links, buttons, selection (iOS light) */
  --apple-label: #000000; /* Primary text (light mode) */
  --apple-secondary-label: #8e8e93; /* Secondary text (systemGray) */
  --apple-system-background: #ffffff; /* Primary background */
  --apple-secondary-background: #f2f2f7; /* Grouped background */
  --apple-separator: #c6c6c8; /* Hairline separators */
  --apple-system-red: #ff3b30; /* Destructive actions */
  --apple-system-green: #34c759; /* Success */
  --apple-system-orange: #ff9500; /* Warnings */

  /* Typography */
  --font-display: -apple-system, 'SF Pro Display', 'Helvetica Neue', sans-serif;
  --font-body: -apple-system, 'SF Pro Text', 'Helvetica Neue', sans-serif;
  --font-mono: 'SF Mono', ui-monospace, Menlo, monospace;

  /* Type scale */
  --text-large-title: 34px; /* line-height 41px */
  --text-title-1: 28px; /* line-height 34px */
  --text-title-2: 22px; /* line-height 28px */
  --text-headline: 17px; /* line-height 22px */
  --text-body: 17px; /* line-height 22px */
  --text-footnote: 13px; /* line-height 18px */

  /* Spacing */
  --space-1: 4px;
  --space-2: 8px;
  --space-3: 16px;
  --space-4: 20px;
  --space-5: 32px;

  /* Radius */
  --radius-controls: 8px;
  --radius-cards-sheets: 10px;
  --radius-continuous-large: 20px;

  /* Elevation */
  --shadow-subtle: 0 2px 10px rgba(0,0,0,0.1);

  /* Motion */
  --motion-standard: 300ms ease-in-out;
  --motion-spring: spring(mass 1, stiffness 100, damping 15);
}
```

## Origin

The Macintosh Human Interface Guidelines first shipped in 1987 and have evolved continuously since — through OS X, iOS, watchOS, tvOS, and now visionOS. The current HIG is a single web reference covering every Apple platform, refreshed in lockstep with WWDC and major OS releases.

## Governance

Apple's Human Interface team owns it; updates ship on Apple's release cadence with no public RFC process or external contribution path. SF Symbols, SF Pro, and the platform component code are gated behind Apple's developer tooling and licenses.

## Known for

- Platform conventions that users genuinely expect — sheets, back gestures, tab bars, navigation stacks, share menus.
- A coherent motion language built on spring physics, with content-first transitions tuned per platform.
- SF Symbols — a 6,000+ icon set that is, in effect, a typographic system you can size, weight, and color like text.

## Underrated

- The accessibility chapter is one of the most operational in the industry — Dynamic Type, VoiceOver hint rules, motion-reduction guidance.
- The visionOS sections quietly redefine spatial UI conventions; depth, glance behavior, and gaze-targeted controls are documented in real detail.

## Watch out for

- HIG is not a downloadable component library — it's guidance plus framework affordances. Outside SwiftUI / UIKit / AppKit you're recreating its components by hand.
- Patterns lean hard on Apple framework defaults (haptics, system sheets, navigation transitions). Lifting them onto Android or the web without translation produces uncanny imitations.

## Components worth studying

- **Tab Bar** — The reference root navigation for iOS apps — three to five top-level destinations, badge support, large-content viewer.
- **Sheet** — Modal presentation with detents (medium, large, custom), drag dismissal, and grabber affordance — the iOS interaction primitive.
- **SF Symbols** — Vector glyphs that align with text baselines, scale with Dynamic Type, and ship in nine weights and three scales.

## When to choose Apple Human Interface Guidelines

If you ship native on any Apple platform, HIG is the foundation, full stop — App Store review reads against it. Don't treat it as a cross-platform system: its assumptions about hardware, gestures, and frameworks don't survive the trip.

## Apply this style with an AI tool

Paste this into your AI coding assistant as a direction, then iterate:

> Design in the spirit of Apple Human Interface Guidelines by Apple — The platform conventions every Apple-shaped product is measured against. Character: The platform vernacular itself: San Francisco type, translucent materials, continuous corners, and physics-true motion everyone imitates. Use a primary colour near #007aff, the typeface "SF Pro Text" (or a close equivalent), corner radius around 8px, a spacing rhythm on a 8px (layout margins 16/20) base. Lean into what it's known for: Platform conventions that users genuinely expect — sheets, back gestures, tab bars, navigation stacks, share menus. Match the intent, not the pixels; adapt it to my product rather than cloning it.

## Official references

- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- [SF Symbols](https://developer.apple.com/sf-symbols/)
- [Apple Design Resources](https://developer.apple.com/design/resources/)
- [Accessibility on Apple platforms](https://developer.apple.com/accessibility/)

---

_Generated by [designsystems.one](https://www.designsystems.one/design-systems/apple-hig) — a catalogue of public design systems. Style facts are reported for reference and education; adapt them to your own product. Report issues or takedown requests via the site._
