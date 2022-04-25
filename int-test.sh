#!/bin/sh

# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#set -u

setup_trap_handler() {
  # shellcheck disable=SC2124
  readonly ANSIBLE_ARGS="$@"
  trap finish EXIT
}

finish() {
  # This function executes on exit and destroys the working project
  echo "$ANSIBLE_ARGS"
  echo "rc=$rc"
  stack_directory=$(dirname "$ANSIBLE_ARGS")
  playbook_name=$(basename "$ANSIBLE_ARGS")
  test_name=${playbook_name%.yml}
  setup_directory="$stack_directory/tf/$test_name"
  project_id=$(terraform -chdir="${setup_directory}" output -raw project_id)
  gcloud projects delete "$project_id" --quiet
}
# shellcheck disable=SC2068
setup_trap_handler ${@}

#mkdir -p $TF_PLUGIN_CACHE_DIR
unset TF_PLUGIN_CACHE_DIR
envd
rc=0 # return code for ansible playbook
# retry playbook in case of a failure
for i in 1 2; do
  echo ansible-playbook "${@}"
  # shellcheck disable=SC2068
  ansible-playbook ${@}
  rc=$?
  echo "rc=$rc" "try=$i"
  if [ "$rc" = "0" ]; then
    break
  fi
done

exit $rc
