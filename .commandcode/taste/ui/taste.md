# ui
- Display form validation errors as field-level inline messages with red borders on the specific input fields, not as a generic message below the form. Confidence: 0.65
- Add three-dot quick action dropdown menus to admin list rows (subscriptions, salons) for inline actions instead of requiring navigation to a detail page. Confidence: 0.75
- Wire all admin UI changes (dropdowns, toggles, quick actions) to backend mutations — do not create UI elements that are purely cosmetic without backend integration. Confidence: 0.70
- Use Switch components for binary/boolean toggles (Enabled/Disabled) instead of Select dropdowns. Confidence: 0.85
- Use SegmentedControl with Show/Hide options for visibility toggles instead of Select dropdowns. Confidence: 0.85
- Apply `align-items: stretch` on CSS Grid rows so cards in the same row have equal height regardless of content volume. Confidence: 0.85
- Do not repeat card subheadings as form row titles within the same visual card boundary. Confidence: 0.80
