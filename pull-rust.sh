#!/bin/sh
set -ue

echo "Checking out rust..." >&2

git submodule update --init rust
cd rust
git fetch
git checkout origin/master
git submodule update --init src/libcompiler_builtins
git submodule update --init src/liblibc
cd ..

echo "Building diff for ja-JP..." >&2
diff -ur en-US ja-JP > ja-JP.patch || true
echo "Patching ja-JP..." >&2
mv ja-JP ja-JP.old
mkdir ja-JP
cp -r \
  rust/src/libcore \
  rust/src/libstd_unicode \
  rust/src/liballoc \
  rust/src/libstd \
  ja-JP
cd ja-JP
patch -p1 < ../ja-JP.patch || true
cd ..
echo "Updating en-US..." >&2
mv en-US en-US.old
mkdir en-US
cp -r \
  rust/src/libcore \
  rust/src/libstd_unicode \
  rust/src/liballoc \
  rust/src/liblibc \
  rust/src/liballoc_system \
  rust/src/libunwind \
  rust/src/libcompiler_builtins \
  rust/src/libstd \
  en-US
echo "Done." >&2
