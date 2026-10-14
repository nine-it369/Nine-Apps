// Nine Apps design tokens — Apple web language (STYLE_GUIDE.md) with the Nine brand green as
// the single accent. Photography-first, quiet chrome: no decorative gradients, no UI shadows,
// one interactive color. SF Pro Display/Text with Inter as the open-source substitute.
// Only tokens actually used by the app are defined; semantic aliases point at the scale.
tailwind.config = {
  theme: {
    extend: {
      colors: {
        // Ink / neutral scale (Apple grays). primary-900 = ink, primary-100 = parchment.
        // Ink / neutral scale (Zinc/Slate matching D:\Frontend-Mall)
        "primary-50": "#fafafa",
        "primary-100": "#f4f4f5",
        "primary-200": "#e4e4e7",
        "primary-300": "#d4d4d8",
        "primary-400": "#a1a1aa",
        "primary-500": "#71717a",
        "primary-600": "#52525b",
        "primary-700": "#3f3f46",
        "primary-800": "#27272a",
        "primary-900": "#18181b",
        "primary-950": "#09090b",

        // Accent — Automotive Emerald Green (100% Frontend-Mall main.css)
        "accent-50": "#f0fdf4",
        "accent-100": "#dcfce7",
        "accent-200": "#bbf7d0",
        "accent-300": "#86efac",
        "accent-400": "#4ade80",
        "accent-500": "#22c55e",
        "accent-600": "#16a34a",
        "accent-700": "#15803d",
        "accent-800": "#166534",
        "accent-900": "#14532d",
        "accent-950": "#052e16",

        "danger-500": "#ef4444",
        "danger-text": "#b91c1c",
        "danger-50": "#fef2f2",
        "warning-500": "#f59e0b",
        "warning-text": "#b45309",
        "warning-50": "#fffbeb",
        "info": "#3b82f6",
        "info-subtle": "#eff6ff",
        "info-text": "#1d4ed8",

        // semantic aliases
        "primary": "#1d1d1f",
        "primary-container": "#1d1d1f",
        "secondary": "#7a7a7a",        // ink-muted-48
        "on-surface": "#1d1d1f",
        "on-surface-variant": "#333333",
        "on-primary": "#ffffff",
        "on-primary-container": "#8e8e93",
        "surface": "#f5f5f7",          // parchment canvas
        "surface-card": "#ffffff",
        "hairline": "#e0e0e0",         // 1px util-card border
        "divider-soft": "#f0f0f0",
        "accent-subtle": "#f0fdf4",
        "accent-pressed": "#166534",
        "accent-text": "#166534",
        "danger": "#ef4444",
        "danger-subtle": "#fef2f2",
        "warning": "#f59e0b",
        "warning-subtle": "#fffbeb",

        "map-land": "#f2efe9"
      },
      // Radii grammar: {sm 8, md 11, lg 18, pill}. Cards = 18px, controls = 8px, CTAs = pill.
      borderRadius: {
        DEFAULT: "8px",
        sm: "8px",
        md: "11px",
        lg: "18px",
        xl: "8px",
        "2xl": "18px",
        "3xl": "18px",
        full: "9999px"
      },
      spacing: {
        gutter: "0.75rem",
        margin: "1rem",
        "space-xs": "0.25rem",
        "space-sm": "0.5rem",
        "space-md": "1rem",
        "space-lg": "1.5rem",
        "space-xl": "2rem",
        section: "5rem"  // 80px — product-tile vertical padding
      },
      fontFamily: {
        micro: ["-apple-system", "BlinkMacSystemFont", "SF Pro Text", "Inter", "system-ui", "sans-serif"],
        body: ["-apple-system", "BlinkMacSystemFont", "SF Pro Text", "Inter", "system-ui", "sans-serif"],
        caption: ["-apple-system", "BlinkMacSystemFont", "SF Pro Text", "Inter", "system-ui", "sans-serif"],
        label: ["-apple-system", "BlinkMacSystemFont", "SF Pro Text", "Inter", "system-ui", "sans-serif"],
        title: ["-apple-system", "BlinkMacSystemFont", "SF Pro Display", "Inter", "system-ui", "sans-serif"],
        "body-semibold": ["-apple-system", "BlinkMacSystemFont", "SF Pro Text", "Inter", "system-ui", "sans-serif"],
        price: ["-apple-system", "BlinkMacSystemFont", "SF Pro Display", "Inter", "system-ui", "sans-serif"],
        headline: ["-apple-system", "BlinkMacSystemFont", "SF Pro Display", "Inter", "system-ui", "sans-serif"],
        display: ["-apple-system", "BlinkMacSystemFont", "SF Pro Display", "Inter", "system-ui", "sans-serif"]
      },
      // Apple type scale. Display weight 600 (never 700/800/900), negative tracking on display.
      fontSize: {
        micro: ["12px", { lineHeight: "16px", letterSpacing: "-0.12px", fontWeight: "400" }],
        label: ["14px", { lineHeight: "18px", letterSpacing: "-0.224px", fontWeight: "600" }],
        caption: ["14px", { lineHeight: "20px", letterSpacing: "-0.224px", fontWeight: "400" }],
        body: ["17px", { lineHeight: "25px", letterSpacing: "-0.374px", fontWeight: "400" }],
        "body-semibold": ["17px", { lineHeight: "22px", letterSpacing: "-0.374px", fontWeight: "600" }],
        title: ["17px", { lineHeight: "22px", letterSpacing: "-0.374px", fontWeight: "600" }],
        price: ["21px", { lineHeight: "25px", letterSpacing: "0.231px", fontWeight: "600" }],
        headline: ["28px", { lineHeight: "32px", letterSpacing: "-0.374px", fontWeight: "600" }],
        display: ["40px", { lineHeight: "44px", letterSpacing: "-0.28px", fontWeight: "600" }]
      }
    }
  }
};
