# Linux window management (GNOME)

This setup is imported **only** by `modules/linux.nix`. The macOS Home Manager
profile and native macOS window-management settings are unchanged.

`modules/gnome.nix` declares native GNOME settings and deploys the small
`dotfiles/config/gnome/manual-layout@dotfiles-nix/` Shell extension through
`xdg.dataFile`. Extension source and compiled settings live in the Nix store;
there is no out-of-store link, hotkey daemon, or automatic tiling manager.

## Shortcuts

Here `Super` is the PC Windows/meta key. `Ctrl+Super` is a held modifier chord,
not a sequential Vim leader.

| Shortcut | Action |
| --- | --- |
| `Super+1` … `Super+6` | Switch to workspace 1 … 6 |
| `Super+Shift+1` … `Super+Shift+6` | Send focused window to workspace and follow |
| `Ctrl+Super+h` | Focused window left, partner right |
| `Ctrl+Super+l` | Focused window right, partner left |
| `Ctrl+Super+k` | Focused window top, partner bottom |
| `Ctrl+Super+j` | Focused window bottom, partner top |
| `Ctrl+Super+f` | Fill usable screen with gaps, not fullscreen |
| `Ctrl+Super+c` | Center at a fixed 80% width and height |
| `Ctrl+Super+m` | Minimize focused window |
| `Super+l` / `Super+Shift+l` | Cycle workspace windows forward/backward |
| `Ctrl+Alt+l` | Lock screen |

There are six fixed workspaces. Workspaces span all monitors, rather than leaving
secondary monitors fixed across workspace switches. Keep terminal, Emacs, and
browser on workspaces 1, 2, and 3 manually; no application-placement rules run.
Native GNOME 50 numbered move commands already follow the moved window.

Native cycling uses GNOME's window cycler, restricted to the current workspace,
across its monitors. Release Super to finish cycling; no Enter is required.
Minimized windows can appear in this native list. There are no directional-focus
bindings. Minimizing a window is not macOS's application-wide Hide.

Favorite-application number shortcuts (switch and launch-new-instance) and
application-level `Alt+Tab`/`Super+Tab` bindings are cleared. Native window/group
shortcuts otherwise remain. `Super+h` minimize and `Super+l` lock are replaced by
the bindings above. The separate hardware screensaver key, if present, remains.

## Arrangement semantics

- A single shortcut arranges both windows, with no chooser or confirmation.
- The focused normal window occupies the requested half. The most recently used
  eligible partner on **the same workspace and monitor** occupies the other.
  A third window is left alone. The focused window retains keyboard focus.
- Minimized, fullscreen, sticky, non-resizable, non-movable, and non-normal
  windows (dialogs, docks, etc.) are excluded. An ineligible focused window makes
  the command a no-op. Leave fullscreen before arranging.
- With only one eligible window, arrangement puts it in the requested half.
- Fill and center affect only the focused window. Center always requests 80% of
  the gap-inset work area's width and height, centered on both axes of the current
  monitor. Previous size and layout do not matter: left/top halves and filled
  windows all become the same centered rectangle. There is no restore history.
- Outer and inter-window gaps are **12 logical pixels**, configurable via `gap`
  in `modules/gnome.nix`. Geometry uses the monitor's usable work area, excluding
  GNOME's panel, and includes the window frame. Shadows may extend into gaps.
- Repeating a command requests the same layout; it is not a maximize/restore
  toggle. There is no saved-layout state or resize coupling between windows.
- Application minimum sizes and terminal character-cell increments can prevent
  exact halves/gaps. Wayland clients acknowledge resize requests asynchronously;
  both requests are issued by one command, not as an atomic compositor operation.

## Activation and verification

Before activation:

```sh
make check
make build-linux LINUX_HOST=linux
# Fast standalone tests (also run when Nix builds the extension):
node --experimental-vm-modules --test tests/gnome-window-management.mjs
```

When ready to change the live session:

```sh
make apply-linux
```

**Log out and back in** to load the newly installed extension and its compiled
schema reliably. Do this after updating the extension too: GNOME caches imported
JavaScript modules. Wayland does not support the Xorg Alt+F2 `r` Shell restart.

The declared enabled-extension list preserves this machine's existing Fedora
background-logo extension and enables Manual Layout. Add any other desired
extensions to that list; activation owns the list, not just our UUID. User
extensions are enabled, but Shell version validation is not bypassed.

After login:

```sh
gnome-extensions info manual-layout@dotfiles-nix
env GSETTINGS_BACKEND=dconf /usr/bin/gsettings get org.gnome.mutter dynamic-workspaces
env GSETTINGS_BACKEND=dconf /usr/bin/gsettings get org.gnome.desktop.wm.preferences num-workspaces
journalctl --user -b -o cat | grep -E 'manual-layout|JS ERROR'
```

The two settings should read `false` and `6`. Explicitly selecting dconf matters:
Nix-packaged GUI applications can pass `GSETTINGS_BACKEND=keyfile` to their child
shells (observed here in a Ghostty-launched Fish session). Plain `gsettings` then
reads a different store and may show defaults `true` and `4`, even though GNOME
and Home Manager use the correctly configured dconf database. Use Fedora's
`/usr/bin/gsettings` with the per-command backend override for GNOME diagnostics;
do not reset workspaces or globally change Nix applications' settings backends.

Manual acceptance checklist (automated tests do not replace this):

1. Confirm `Super+1…6`, numbered move-and-follow, and `Ctrl+Alt+l` lock.
2. Launch terminal, Emacs, and browser; place them on workspaces 1, 2, and 3.
3. With one window, test fill, all four half positions, center, and minimize.
   After each half position and fill, center should produce the same smaller
   rectangle centered on both axes. Repeat on each monitor.
4. Move browser to Emacs's workspace and follow it. Test all four pair layouts
   from either focused window. Each command must place both without prompting.
5. Test `Super+l` and its Shift variant, including repeated presses and holding
   Super while cycling. Neither should switch workspaces or lock the screen.
6. Add a third window; confirm the MRU partner is chosen and the third is untouched.
   Check minimized windows and dialogs are not used as arrangement partners.
7. Test from native maximized and edge-tiled states. Check both native Wayland
   and XWayland applications, minimum-size behavior, and fractional scaling.
8. If using multiple monitors, test each monitor, including one left of the
   primary (negative coordinates). Arrangement must not pull in another monitor's
   windows. Check workspace switching affects all monitors as intended.
9. Disable the extension and confirm native workspace, move-and-follow, cycling,
   minimize, and lock shortcuts still work; re-enable and retest arrangement.

## Maintenance and recovery

The helper uses GNOME Shell's standard extension/keybinding interface and
Mutter's introspected window APIs. It registers six keybindings only: no window
signals, timers, injected Shell methods, UI, pointer automation, or background
layout tracking. Native GNOME handles everything else.

**Compatibility is limited to GNOME 50.** The implementation was checked against
GNOME/Mutter 50.4 source; `unmaximize()` takes no arguments in that release.
Metadata is not a claim that live compositor testing has already passed. Unit
tests check geometry, partner selection, command dispatch, and lifecycle using
API doubles; they cannot validate real Wayland resize negotiation.

Before a major Fedora/GNOME upgrade, review the relevant APIs and run the manual
checklist in the new session before adding its version to `metadata.json`.
Do not disable extension-version validation or merely add future versions without
testing. Pinning extension source with Nix does not pin Fedora's GNOME runtime.
This has a smaller maintenance surface than an automatic tiler, not immunity to
GNOME upgrades.

The optional `version` field is deliberately omitted from `metadata.json`.
This extension is not published on extensions.gnome.org; Git/Nix owns its updates.
The service was observed returning a bogus `upgrade` for our UUID with `version: 1`,
followed by a 404 when Shell tried to download it. Sending metadata without that
field returned no update. Do not add a catalog version for local releases or
patch Shell's update machinery; other extensions keep their normal update checks.
Log out/in after deploying this metadata change so Shell reloads it.

To temporarily disable only arrangement/fill/center:

```sh
gnome-extensions disable manual-layout@dotfiles-nix
```

Native workspace and navigation shortcuts remain usable. Re-enable with
`gnome-extensions enable manual-layout@dotfiles-nix`; a subsequent Home Manager
activation may also restore the declared enabled list. For persistent disabling,
remove the UUID from `enabled-extensions` in `modules/gnome.nix` and apply.

Rolling back a Home Manager generation restores its declared files/settings;
log out/in after rollback to reload extension code. Removing a dconf declaration
alone does not necessarily restore its prior/default value: explicitly reset
unwanted keys if retiring the setup entirely.
