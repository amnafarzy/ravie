# UI conventions

These rules apply when building or modifying frontend UI components.

## Design system
- Use existing tokens before creating new ones
- Propose new tokens for approval — don't silently expand the system
- Use semantic color names (background, surface, accent) not raw values
- Tailwind classes inline; extract to component when used 3+ times

## States
Every interactive component needs ALL of these states:
- Default, hover, focus (keyboard), active/pressed
- Disabled (if applicable)
- Loading, empty, error, success

If the design only shows default state, implement the others using design system defaults and flag for designer review.

## Responsive
- Mobile-first: start at 375px, expand upward
- Breakpoints: 375 (mobile), 768 (tablet), 1280 (desktop)
- Touch targets minimum 44x44px on mobile
- Never ship accidental horizontal overflow

## Accessibility
- Semantic HTML elements (button for actions, a for navigation)
- Visible focus indicators — never remove them
- ARIA labels for icon-only controls
- Keyboard navigation must work
- Reduced motion: `prefers-reduced-motion` respected
- Color is never the only indicator of state

## Copy
- Buttons: specific verb ("Save changes", not "Submit")
- Errors: what happened + what to do ("Email already registered. Try logging in.")
- Empty states: what goes here + how to add the first item
- Never blame the user in error messages
