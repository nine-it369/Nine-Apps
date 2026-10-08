// Nine Mall / Autogarage tokens — zinc scale + emerald accent, per STYLE_GUIDE_mall.md §2.
// Only tokens actually used by the app are defined; semantic aliases point at the scale.
tailwind.config = {
  theme: {
    extend: {
      colors: {
        // Primary — Dark Slate / Zinc 900
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

        // Accent / success
        "accent-50": "#f0fdf4",
        "accent-500": "#22c55e",
        "accent-600": "#16a34a",
        "accent-700": "#15803d",

        "danger-500": "#ef4444",
        "danger-text": "#b91c1c",    // 5.9:1 on danger-50 / 6.5:1 on white
        "danger-50": "#fef2f2",
        "warning-500": "#f59e0b",
        "warning-text": "#b45309",   // 4.8:1 on warning-50 / 5.0:1 on white
        "warning-50": "#fffbeb",
        "info": "#3b82f6",
        "info-subtle": "#eff6ff",
        "info-text": "#1d4ed8",      // 6.2:1 on info-50 / 6.7:1 on white

        // semantic aliases
        "primary": "#18181b",
        "primary-container": "#18181b",
        "secondary": "#71717a",
        "on-surface": "#18181b",
        "on-surface-variant": "#52525b",
        "on-primary": "#ffffff",
        "on-primary-container": "#a1a1aa",
        "surface": "#fafafa",
        "surface-card": "#ffffff",
        "accent-subtle": "#f0fdf4",
        "accent-pressed": "#16a34a",
        "accent-text": "#15803d",
        "danger": "#ef4444",
        "danger-subtle": "#fef2f2",
        "warning": "#f59e0b",
        "warning-subtle": "#fffbeb",

        // OpenStreetMap tile colours are the one documented exception to the token rule
        "map-land": "#f2efe9"
      },
      borderRadius: {
        DEFAULT: "0.25rem",
        lg: "0.5rem",
        xl: "0.75rem",
        full: "9999px"
      },
      spacing: {
        gutter: "0.75rem",
        margin: "1rem",
        "space-xs": "0.25rem",
        "space-sm": "0.5rem",
        "space-md": "1rem",
        "space-lg": "1.25rem",
        "space-xl": "1.5rem"
      },
      fontFamily: {
        micro: ["SF Pro Text", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        body: ["SF Pro Text", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        caption: ["SF Pro Text", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        label: ["SF Pro Text", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        title: ["SF Pro Display", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        "body-semibold": ["SF Pro Text", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        price: ["SF Pro Display", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        headline: ["SF Pro Display", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"],
        display: ["SF Pro Display", "SF Pro", "-apple-system", "BlinkMacSystemFont", "sans-serif"]
      },
      fontSize: {
        // 9px black uppercase — status chips, vehicle type
        micro: ["9px", { lineHeight: "12px", letterSpacing: "0.12em", fontWeight: "900" }],
        // 11px bold uppercase — section labels, SKU, column headers
        label: ["11px", { lineHeight: "14px", letterSpacing: "0.15em", fontWeight: "700" }],
        caption: ["12px", { lineHeight: "16px", fontWeight: "400" }],
        body: ["14px", { lineHeight: "20px", fontWeight: "400" }],
        "body-semibold": ["14px", { lineHeight: "20px", fontWeight: "600" }],
        title: ["16px", { lineHeight: "22px", fontWeight: "700" }],
        price: ["18px", { lineHeight: "24px", letterSpacing: "-0.01em", fontWeight: "900" }],
        headline: ["20px", { lineHeight: "26px", letterSpacing: "-0.01em", fontWeight: "800" }],
        display: ["24px", { lineHeight: "30px", letterSpacing: "-0.02em", fontWeight: "900" }]
      }
    }
  }
};