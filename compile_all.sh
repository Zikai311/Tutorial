#!/usr/bin/env bash

set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
status=0

while IFS= read -r -d '' tex_file; do
  tex_dir="$(dirname "$tex_file")"
  tex_name="$(basename "$tex_file")"

  printf 'Compiling %s\n' "${tex_file#"$script_dir"/}"
  if ! (cd "$tex_dir" && xelatex -interaction=nonstopmode -halt-on-error "$tex_name" >/dev/null); then
    printf 'Failed: %s\n' "${tex_file#"$script_dir"/}" >&2
    status=1
  fi
done < <(find "$script_dir" -type f -name '*.tex' -print0)

if [ "$status" -eq 0 ]; then
  printf 'All TeX files compiled successfully.\n'
else
  printf 'One or more TeX files failed to compile.\n' >&2
fi

exit "$status"
