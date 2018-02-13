#!/bin/sh
set -ue

externs="-L target/ja-JP"
# core -> {}
# std_unicode -> {core}
# alloc -> {core, std_unicode}
# alloc_system -> {core, libc}
# unwind -> {core, libc}
# compiler_builtins -> {core}
# std -> {core, alloc, alloc_system, std_unicode, libc, unwind, compiler_buitins}
for crate in core std_unicode alloc libc alloc_system unwind compiler_builtins std; do
  if [ -d "ja-JP/lib$crate" ]; then
    srclang="ja-JP"
  else
    srclang="en-US"
  fi
  srclib=$srclang/lib$crate/lib.rs
  if [ "$crate" = "libc" -o "$crate" = "compiler_builtins" ]; then
    srclib=$srclang/lib$crate/src/lib.rs
  fi

  echo "rustc $srclang/lib$crate/lib.rs..." >&2
  rustc --out-dir target/ja-JP $externs --crate-type lib \
    --crate-name $crate $srclib
  externs="$externs --extern $crate=target/ja-JP/lib$crate.rlib"

  if [ "$srclang" = "ja-JP" ]; then
    echo "rustdoc ja-JP/lib$crate/lib.rs..." >&2
    rustdoc -o doc/ja-JP $externs \
      --crate-name $crate $srclib
  fi
done
echo "done." >&2
