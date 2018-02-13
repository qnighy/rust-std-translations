#!/bin/sh
set -ue

for crate in core alloc std_unicode std; do
  echo "rustdoc ja-JP/lib$crate/lib.rs..." >&2
  rustdoc -o doc/ja-JP --crate-name $crate ja-JP/lib$crate/lib.rs
done
echo "done." >&2
