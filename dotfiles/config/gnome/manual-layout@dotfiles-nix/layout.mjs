// Pure geometry in Mutter's logical coordinates, including window frames.
// Never multiply by monitor scale: that would double-scale HiDPI displays.
export function layoutRects(area, gap, action) {
  if (area.width < 2 || area.height < 2)
    return null;

  // Keep even pathological work areas usable (two >= 1px halves).
  gap = Math.max(0, Math.min(Math.floor(gap),
    Math.floor((Math.min(area.width, area.height) - 2) / 3)));
  const inner = {
    x: area.x + gap,
    y: area.y + gap,
    width: area.width - 2 * gap,
    height: area.height - 2 * gap,
  };

  if (action === 'fill')
    return [inner];
  if (action === 'center') {
    // A fixed centered layout, not a move-only operation: fill -> center must
    // also shrink the window. No previous geometry or restore state is needed.
    const width = Math.max(1, Math.floor(inner.width * 0.8));
    const height = Math.max(1, Math.floor(inner.height * 0.8));
    return [{
      x: inner.x + Math.floor((inner.width - width) / 2),
      y: inner.y + Math.floor((inner.height - height) / 2),
      width,
      height,
    }];
  }

  const horizontal = action === 'left' || action === 'right';
  if (!horizontal && action !== 'top' && action !== 'bottom')
    throw new Error(`Unknown layout action: ${action}`);
  const size = horizontal ? 'width' : 'height';
  const position = horizontal ? 'x' : 'y';
  const first = {...inner};
  const second = {...inner};
  first[size] = Math.floor((inner[size] - gap) / 2);
  second[size] = inner[size] - gap - first[size];
  second[position] += first[size] + gap;
  return action === 'right' || action === 'bottom'
    ? [second, first] : [first, second];
}
