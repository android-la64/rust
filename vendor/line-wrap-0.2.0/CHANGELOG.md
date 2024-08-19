# 0.2.0

- Remove unmaintained `safemem` dependency
- MSRV is now 1.37.0
- `LineEnding::len()` now returns `NonZeroUsize` since it must be nonzero anyway.
- `SliceLineEnding::new()` returns `Option` to ensure that the slice is non-empty.
- `no_std` friendly
- Explicitly forbid unsafe, not that there was any
