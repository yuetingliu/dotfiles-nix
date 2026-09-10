import assert from 'node:assert/strict';
import {readFile} from 'node:fs/promises';
import path from 'node:path';
import {fileURLToPath, pathToFileURL} from 'node:url';
import {test} from 'node:test';
import vm from 'node:vm';

const directory = process.env.EXTENSION_DIR ?? fileURLToPath(
  new URL('../dotfiles/config/gnome/manual-layout@dotfiles-nix/', import.meta.url));
const {layoutRects} = await import(pathToFileURL(path.join(directory, 'layout.mjs')));
const area = {x: -1920, y: 32, width: 1920, height: 1048};

for (const [forward, reverse, dimension, coordinate] of [
  ['left', 'right', 'width', 'x'],
  ['top', 'bottom', 'height', 'y'],
]) {
  test(`${forward}/${reverse}: exact gaps, opposite sides, odd dimensions`, () => {
    for (const width of [1919, 1920]) {
      for (const height of [1047, 1048]) {
        const work = {...area, width, height};
        const [first, second] = layoutRects(work, 12, forward);
        assert.deepEqual(layoutRects(work, 12, reverse), [second, first]);
        assert.equal(first[coordinate], work[coordinate] + 12);
        assert.equal(second[coordinate] - first[coordinate] - first[dimension], 12);
        assert.equal(second[coordinate] + second[dimension],
          work[coordinate] + work[dimension] - 12);
        assert.ok(Math.abs(first[dimension] - second[dimension]) <= 1);
      }
    }
  });
}

test('fill uses logical work area, not entire monitor', () => {
  assert.deepEqual(layoutRects(area, 12, 'fill'), [
    {x: -1908, y: 44, width: 1896, height: 1024},
  ]);
});

test('center is a fixed size centered on both axes, including odd dimensions', () => {
  assert.deepEqual(layoutRects(area, 12, 'center'), [
    {x: -1718, y: 146, width: 1516, height: 819},
  ]);
  for (const work of [area, {x: 0, y: -1080, width: 1365, height: 767}]) {
    const [rect] = layoutRects(work, 12, 'center');
    assert.equal(rect.width, Math.floor((work.width - 24) * 0.8));
    assert.equal(rect.height, Math.floor((work.height - 24) * 0.8));
    assert.ok(Math.abs(rect.x + rect.width / 2 - work.x - work.width / 2) <= 0.5);
    assert.ok(Math.abs(rect.y + rect.height / 2 - work.y - work.height / 2) <= 0.5);
  }
});

test('local extension omits the optional online-catalog version', async () => {
  const metadata = JSON.parse(await readFile(path.join(directory, 'metadata.json'), 'utf8'));
  assert.equal(metadata.uuid, 'manual-layout@dotfiles-nix');
  assert.equal(Object.hasOwn(metadata, 'version'), false);
});

test('zero gaps, tiny work areas, and invalid actions', () => {
  assert.equal(layoutRects(area, 0, 'left')[0].width, 960);
  assert.deepEqual(layoutRects({x: 0, y: 0, width: 2, height: 2}, 128, 'left'), [
    {x: 0, y: 0, width: 1, height: 2},
    {x: 1, y: 0, width: 1, height: 2},
  ]);
  assert.equal(layoutRects({...area, width: 0}, 12, 'fill'), null);
  assert.throws(() => layoutRects(area, 12, 'unknown'));
});

// Test the real entry point with narrow GNOME API doubles. This checks command
// behavior and lifecycle, not Mutter's actual Wayland resize negotiation.
async function harness(failAt = null) {
  const workspace = {get_work_area_for_monitor: () => area};
  const bindings = new Map();
  const display = {focus_window: null, windows: [], get_tab_list: () => display.windows};
  const context = vm.createContext({
    global: {display, workspace_manager: {get_active_workspace: () => workspace}},
  });
  const makeModule = exports => new vm.SyntheticModule(Object.keys(exports), function () {
    for (const [key, value] of Object.entries(exports))
      this.setExport(key, value);
  }, {context});
  const imports = {
    'gi://Meta': makeModule({default: {
      WindowType: {NORMAL: 0}, TabList: {NORMAL_ALL: 0}, KeyBindingFlags: {NONE: 0},
    }}),
    'gi://Shell': makeModule({default: {ActionMode: {NORMAL: 1}}}),
    'resource:///org/gnome/shell/extensions/extension.js': makeModule({Extension: class {
      getSettings() { return {get_int: () => 12}; }
    }}),
    'resource:///org/gnome/shell/ui/main.js': makeModule({wm: {
      addKeybinding(name, settings, flags, mode, handler) {
        assert.equal(mode, 1); // Never run while locked or in the overview.
        if (name === failAt)
          throw new Error('registration failed');
        bindings.set(name, handler);
      },
      removeKeybinding(name) { bindings.delete(name); },
    }}),
    './layout.mjs': makeModule({layoutRects}),
  };
  const source = await readFile(path.join(directory, 'extension.js'), 'utf8');
  const module = new vm.SourceTextModule(source, {context});
  await module.link(specifier => imports[specifier]);
  await module.evaluate();
  const extension = new module.namespace.default();
  function window(properties = {}) {
    return {
      calls: [], minimized: false,
      get_window_type: () => 0,
      is_fullscreen: () => false,
      is_maximized: () => false,
      is_on_all_workspaces: () => false,
      get_workspace: () => workspace,
      get_monitor: () => 0,
      allows_move: () => true,
      allows_resize: () => true,
      get_frame_rect() { throw new Error('Layout must not depend on previous geometry'); },
      unmaximize(...args) { assert.equal(args.length, 0); this.calls.push('unmaximize'); },
      move_resize_frame(...args) { this.calls.push(args); },
      ...properties,
    };
  }
  return {extension, bindings, display, window, workspace};
}

test('registers six commands and cleans up on disable/re-enable', async () => {
  const {extension, bindings} = await harness();
  for (let i = 0; i < 2; i++) {
    extension.enable();
    assert.equal(bindings.size, 6);
    extension.disable();
    assert.equal(bindings.size, 0);
    assert.equal(extension._settings, null);
  }
  extension.disable();
});

test('partial registration failure cleans up', async () => {
  const {extension, bindings} = await harness('arrange-top');
  assert.throws(() => extension.enable(), /registration failed/);
  assert.equal(bindings.size, 0);
});

test('one command arranges eligible MRU pair only and preserves focus', async () => {
  const {extension, bindings, display, window} = await harness();
  extension.enable();
  const focused = window();
  const ignored = [
    window({minimized: true}),
    window({get_monitor: () => 1}),
    window({get_workspace: () => ({})}),
    window({get_window_type: () => 1}),
    window({is_fullscreen: () => true}),
    window({is_on_all_workspaces: () => true}),
    window({allows_resize: () => false}),
    window({allows_move: () => false}),
  ];
  const partner = window();
  const third = window();
  display.focus_window = focused;
  display.windows = [focused, ...ignored, partner, third];
  for (const action of ['left', 'right', 'top', 'bottom']) {
    const rects = layoutRects(area, 12, action);
    bindings.get(`arrange-${action}`)();
    for (const [index, target] of [focused, partner].entries()) {
      const r = rects[index];
      assert.deepEqual(target.calls.slice(-2), [
        'unmaximize', [true, r.x, r.y, r.width, r.height],
      ]);
    }
    assert.equal(display.focus_window, focused);
  }
  for (const target of [...ignored, third])
    assert.deepEqual(target.calls, []);
});

test('maximized windows remain eligible despite Mutter denying resize', async () => {
  const {extension, bindings, display, window} = await harness();
  extension.enable();
  const focused = window({is_maximized: () => true, allows_resize: () => false});
  const partner = window({is_maximized: () => true, allows_resize: () => false});
  display.focus_window = focused;
  display.windows = [focused, partner];
  bindings.get('arrange-left')();
  assert.equal(focused.calls[0], 'unmaximize');
  assert.equal(partner.calls[0], 'unmaximize');
  assert.equal(focused.calls.length, 2);
  assert.equal(partner.calls.length, 2);
});

test('center after any layout uses only the current monitor work area', async () => {
  const {extension, bindings, display, window, workspace} = await harness();
  extension.enable();
  const focused = window({get_monitor: () => 1});
  display.focus_window = focused;
  display.windows = [focused];
  const work = {x: 1920, y: 0, width: 2560, height: 1440};
  workspace.get_work_area_for_monitor = monitor => {
    assert.equal(monitor, 1);
    return work;
  };
  const [r] = layoutRects(work, 12, 'center');
  for (const previous of ['arrange-left', 'arrange-right', 'arrange-top', 'arrange-bottom', 'fill', 'center']) {
    bindings.get(previous)();
    bindings.get('center')();
    assert.deepEqual(focused.calls.slice(-2), [
      'unmaximize', [true, r.x, r.y, r.width, r.height],
    ]);
  }
});

test('single-window commands, idempotence, and no focused window', async () => {
  const {extension, bindings, display, window} = await harness();
  extension.enable();
  bindings.get('fill')(); // Empty workspace: no-op.
  const focused = window();
  display.focus_window = focused;
  display.windows = [focused];
  for (const [binding, action] of [['arrange-left', 'left'], ['fill', 'fill'], ['center', 'center']]) {
    for (let i = 0; i < 2; i++) {
      bindings.get(binding)();
      const [r] = layoutRects(area, 12, action);
      assert.deepEqual(focused.calls.at(-1), [true, r.x, r.y, r.width, r.height]);
    }
  }
  focused.calls = [];
  focused.is_fullscreen = () => true;
  bindings.get('fill')();
  assert.deepEqual(focused.calls, []);
});
