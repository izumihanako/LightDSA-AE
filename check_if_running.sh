#!/usr/bin/env bash
# Check if *other users* are running LightDSA AE-related scripts/processes.
# Exit 0: no others running; Exit 2: found others running.

set -e
 
PATTERN='(reproduce\.sh|runner\.sh|env_init\.sh|step[0-9]+\.sh|perf[^ ]*\.py|figure[0-9]+|redis*)'
# sudo pgrep -fa 'figure*|reproduce\.sh|runner*|env_init*|redis*|step.\.sh' | grep -v 'pgrep'
 
matches="$(ps -eo user=,pid=,ppid=,etimes=,args= \
  | grep -E "$PATTERN" \
  | grep -v -E "grep|pgrep|${0##*/}")" || true

if [ -n "$matches" ]; then
  echo "⚠ Detected experiments running:"
  echo "USER       PID     PPID  ELAPSED CMD"
  echo "$matches"
  echo
  echo "Please wait until these runs finish before starting new experiments."
  exit 2
else
  echo "✓ No experiments from other users detected."
  exit 0
fi