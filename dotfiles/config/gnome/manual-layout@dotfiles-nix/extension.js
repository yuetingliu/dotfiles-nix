import Meta from 'gi://Meta';
import Shell from 'gi://Shell';
import {Extension} from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

import {layoutRects} from './layout.mjs';

export default class ManualLayout extends Extension {
  enable() {
    this._settings = this.getSettings();
    this._bindings = [];
    try {
      for (const action of ['left', 'right', 'top', 'bottom', 'fill', 'center']) {
        const name = ['fill', 'center'].includes(action) ? action : `arrange-${action}`;
        Main.wm.addKeybinding(name, this._settings,
          Meta.KeyBindingFlags.NONE, Shell.ActionMode.NORMAL,
          () => this._layout(action));
        this._bindings.push(name);
      }
    } catch (error) {
      this.disable();
      throw error;
    }
  }

  disable() {
    for (const name of this._bindings ?? [])
      Main.wm.removeKeybinding(name);
    this._bindings = [];
    this._settings = null;
  }

  _eligible(window, workspace, monitor) {
    return window !== null &&
      window.get_window_type() === Meta.WindowType.NORMAL &&
      !window.minimized && !window.is_fullscreen() &&
      !window.is_on_all_workspaces() &&
      window.get_workspace() === workspace &&
      window.get_monitor() === monitor &&
      window.allows_move() &&
      // Mutter reports allows_resize() = false while maximized. These windows
      // are still eligible: _place() unmaximizes before requesting geometry.
      (window.allows_resize() || window.is_maximized());
  }

  _place(window, rect) {
    // GNOME 50: unmaximize() takes no flags. Also clears native edge tiling.
    // Both requests are issued together; no timers or persistent window state.
    window.unmaximize();
    window.move_resize_frame(true, rect.x, rect.y, rect.width, rect.height);
  }

  _layout(action) {
    const window = global.display.focus_window;
    if (!window)
      return;
    const workspace = global.workspace_manager.get_active_workspace();
    const monitor = window.get_monitor();
    if (!this._eligible(window, workspace, monitor))
      return;

    const rects = layoutRects(workspace.get_work_area_for_monitor(monitor),
      this._settings.get_int('gap'), action);
    if (!rects)
      return;

    if (rects.length === 2) {
      // Mutter supplies MRU ordering; no chooser, application rules, or tracking.
      const partner = global.display.get_tab_list(Meta.TabList.NORMAL_ALL, workspace)
        .find(candidate => candidate !== window &&
          this._eligible(candidate, workspace, monitor));
      if (partner)
        this._place(partner, rects[1]);
    }
    this._place(window, rects[0]);
    // Moving/resizing does not transfer keyboard focus. Do not activate a
    // partner, warp the pointer, or touch windows on another monitor/workspace.
  }
}
