#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# find_files is a helper to exclude .git directories and match only regular
# files to avoid double-processing symlinks.
# You can ignore directories by setting two different environment variables of
#   relative escaped paths separated by a pipe
# (1) EXCLUDE_LINT_DIRS - all files pointed to by this variable are skipped
#                         during ANY USE of the find_files function
#     E.g.: EXCLUDE_LINT_DIRS="\./scripts/foo|\./scripts/bar"
# (2) EXCLUDE_HEADER_CHECK - all files pointed to by this variable are skipped
#                            ONLY WHEN the "for_header_check" flag is passed in
#     E.g.: EXCLUDE_HEADER_CHECK="\./config/foo_resource.yml|\./scripts/bar_script.sh"
find_files() {
  local pth="$1" find_path_regex="(" exclude_dirs=( ".*/\.git"
    ".*/\.terraform"
    ".*/\.kitchen"
    ".*/.*\.png"
    ".*/.*\.jpg"
    ".*/.*\.jpeg"
    ".*/.*\.svg"
    "\./venv"
    "\./autogen"
    "\./third_party"
    "\./test/fixtures/all_examples"
    "\./test/fixtures/shared"
    "\./cache"
    "\./test/source\.sh" )
  shift

  # Concat all of the above dirs except the last, separated by a pipe
  for ((index=0; index<$((${#exclude_dirs[@]}-1)); ++index)); do
    find_path_regex+="${exclude_dirs[index]}|"
  done

  # Add any regex supplied to ignore other dirs
  if [[ -n "${EXCLUDE_LINT_DIRS-}" ]]; then
    find_path_regex+="${EXCLUDE_LINT_DIRS}"
    find_path_regex+="|"
  fi

  # if find_files is used for validating license headers
  if [ $1 = "for_header_check" ]; then
    # Add any files to be skipped for header check
    if [[ -n "${EXCLUDE_HEADER_CHECK-}" ]]; then
      find_path_regex+="${EXCLUDE_HEADER_CHECK}"
      find_path_regex+="|"
    fi
    shift
  fi

  # Concat last dir, along with closing paren
  find_path_regex+="${exclude_dirs[-1]})"
  # find_path_regex should be a string of this format:
  # (some_relative_path|another_relative_path)
  # ex: find_path_regex = (.*/\.git|.*/\.terraform|.*/\.kitchen|.*/.*\.png)

  # Note: Take care to use -print or -print0 when using this function,
  # otherwise excluded directories will be included in the output.
  find "${pth}" -regextype posix-egrep -regex "${find_path_regex}" \
    -prune -o -type f "$@"
}

# Compatibility with both GNU and BSD style xargs.
compat_xargs() {
  local compat=()
  # Test if xargs is GNU or BSD style.  GNU xargs will succeed with status 0
  # when given --no-run-if-empty and no input on STDIN.  BSD xargs will fail and
  # exit status non-zero If xargs fails, assume it is BSD style and proceed.
  # stderr is silently redirected to avoid console log spam.
  if xargs --no-run-if-empty </dev/null 2>/dev/null; then
    compat=("--no-run-if-empty")
  fi
  xargs "${compat[@]}" "$@"
}

# This function creates TF_PLUGIN_CACHE_DIR if TF_PLUGIN_CACHE_DIR envvar is set
function init_tf_plugin_cache() {
  if [[ ! -z "${TF_PLUGIN_CACHE_DIR}" ]]; then
    mkdir -p ${TF_PLUGIN_CACHE_DIR}
  fi
}

# This function runs 'terraform validate' against all
# directory paths which contain *.tf files.
function check_terraform() {
  set -e
  local rval rc
  rval=0

  init_tf_plugin_cache

  # fmt is before validate for faster feedback, validate requires terraform
  # init which takes time.
  echo "Running terraform fmt"
  while read -r file; do
    terraform fmt -diff -check=true -write=false "$file"
    rc="$?"
    if [[ "${rc}" -ne 0 ]]; then
      echo "Error: terraform fmt failed with exit code ${rc}" >&2
      echo "Check the output for diffs and correct using terraform fmt <dir>" >&2
      rval="$rc"
    fi
  done <<< "$(find_files . -name "*.tf" -print)"
  if [[ "${rval}" -ne 0 ]]; then
    return "${rval}"
  fi
  echo "Running terraform validate"
  # Change to a temporary directory to avoid re-initializing terraform init
  # over and over in the root of the repository.

  # If enable parallel, run validate in parallel
  if [[ "${ENABLE_PARALLEL:-}" -eq 1 ]]; then
    find_files . -name "*.tf" -print \
    | grep -v 'test/fixtures/shared' \
    | compat_xargs -n1 dirname \
    | sort -u \
    | parallel --keep-order --retries 3 --joblog /tmp/lint_log terraform_validate
    cat /tmp/lint_log
  else
    find_files . -name "*.tf" -print \
    | grep -v 'test/fixtures/shared' \
    | compat_xargs -n1 dirname \
    | sort -u \
    | compat_xargs -t -n1 terraform_validate
  fi
}

# Check for common whitespace errors:
# Trailing whitespace at the end of line
# Missing newline at end of file
check_whitespace() {
  local rc
  echo "Checking for trailing whitespace"
  find_files . -print \
    | grep -v -E '\.(pyc|png|gz|tfvars)$' \
    | compat_xargs grep -H -n '[[:blank:]]$'
  rc=$?
  if [[ ${rc} -eq 0 ]]; then
    printf "Error: Trailing whitespace found in the lines above.\n\n"
    ((rc++))
  else
    rc=0
  fi
  echo "Checking for missing newline at end of file"
  find_files . -print \
    | grep -v -E '\.(png|gz|tfvars)$' \
    | compat_xargs check_eof_newline
  return $((rc+$?))
}

# This function runs the shellcheck linter on every
# file ending in '.sh'
function check_shell() {
  echo "Running shellcheck"
  find_files . -name "*.sh" -print0 | compat_xargs -0 shellcheck -x
}

# This function runs the flake8 linter on every file
# ending in '.py'
function check_python() {
  echo "Running flake8"
  find_files . -name "*.py" -print0 | compat_xargs -0 flake8
}

function check_headers() {
  echo "Checking file headers"
  # Use the exclusion behavior of find_files(); a second argument
  # "for_header_check" is passed in, to ensure filtering based on the evironment
  # variable EXCLUDE_HEADER_CHECK is done only when find_files is called here
  find_files . for_header_check -type f -print0 | compat_xargs -0 addlicense -check 2>&1
}

function check_ansible() {
  echo "Running ansible-lint"
  ansible-lint
}