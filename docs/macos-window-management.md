# macOS Window Management

The macOS profile uses native Spaces, Mission Control, and window tiling. It
does not install a tiling window manager or global hotkey daemon.

## One-Time Setup

1. Open Mission Control and create six desktop Spaces.
2. In **System Settings → Keyboard → Keyboard Shortcuts → Mission Control**,
   enable “Switch to Desktop 1” through “Switch to Desktop 6” and assign
   `Option-1` through `Option-6`.
3. Assign `Option-O` to Mission Control in the same settings panel.
4. Under **Keyboard Shortcuts → App Shortcuts**, add these shortcuts for
   **All Applications** using the menu item names exactly as written:

   - `Fill`: `Control-Option-F`
   - `Left & Right`: `Control-Option-H`
   - `Right & Left`: `Control-Option-L`
   - `Bottom & Top`: `Control-Option-J`
   - `Top & Bottom`: `Control-Option-K`

5. Under **Keyboard Shortcuts → Keyboard**, assign `Option-L` to **Move focus
   to active or next window**. Use `Option-Shift-L` to cycle in reverse. macOS
   exposes one cycling command, so separate native `Option-H` and `Option-L`
   previous/next bindings are not available without a key-remapping tool.
6. Remove the old Raycast `Option-T`, `Option-E`, and `Option-B` application
   hotkeys; application navigation now happens by switching Spaces.
7. In **System Settings → Accessibility → Display**, enable **Reduce motion**.
   macOS protects this preference from command-line configuration.
8. Run `make apply`, then log out and back in so the Spaces, motion, and
   window-management defaults are applied consistently.

Keep terminal, Emacs, and the browser on Spaces 1, 2, and 3 respectively. Avoid
macOS full-screen mode because it creates additional Spaces; use the fill
binding instead.

## Keybindings

| Binding | Action |
| --- | --- |
| `Option-1` … `Option-6` | Switch Space |
| `Option-O` | Show Mission Control |
| `Option-L` / `Option-Shift-L` | Focus next / previous window |
| `Control-Option-H` | Active window left, second window right |
| `Control-Option-L` | Active window right, second window left |
| `Control-Option-J` | Active window bottom, second window top |
| `Control-Option-K` | Active window top, second window bottom |
| `Control-Option-F` | Fill the desktop |

The shortcut assignments are intentionally manual because macOS owns them and
stores them as user preferences. Nix continues to manage the stable window and
Spaces defaults.
