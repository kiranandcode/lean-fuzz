#!/usr/bin/env bash
#
# collect-stats.sh -- libFuzzer monitoring daemon
#
# Reads /root/lean-fuzz/fuzz.log, parses libFuzzer progress lines,
# collects crash info, and writes JSON files consumed by the dashboard.
#
# Usage:  ./collect-stats.sh          (runs forever, Ctrl-C to stop)
#         ./collect-stats.sh --once   (single collection, then exit)
#
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
FUZZ_DIR="/root/lean-fuzz"
FUZZ_LOG="${FUZZ_DIR}/fuzz.log"
CORPUS_DIR="${FUZZ_DIR}/corpus"
LAST_INPUT="${FUZZ_DIR}/last-fuzz-input.lean"
API_DIR="/var/www/fuzz/api"
STATS_FILE="${API_DIR}/stats.json"
CRASHES_FILE="${API_DIR}/crashes.json"
PLOT_FILE="${API_DIR}/plot.json"
INTERVAL=5

export PATH="$HOME/.elan/bin:$PATH"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log() { printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"; }

json_escape() {
    # Escape a string for safe embedding in JSON.
    # Handles backslash, double-quote, control characters, and newlines.
    python3 -c '
import json, sys
s = sys.stdin.read()
sys.stdout.write(json.dumps(s))
'
}

bytes_to_hex() {
    # Convert a binary file to space-separated hex bytes.
    xxd -p "$1" 2>/dev/null | sed 's/../& /g' | tr -d '\n' | sed 's/ $//'
}

ensure_dir() {
    mkdir -p "$API_DIR"
}

# ---------------------------------------------------------------------------
# Parse the latest libFuzzer progress line
# ---------------------------------------------------------------------------
parse_latest_line() {
    # Returns tab-separated: execs cov ft corp_count corp_bytes exec_s rss_mb
    # A typical libFuzzer line looks like:
    #   #1234  NEW    cov: 504 ft: 515 corp: 3/10b lim: 4 exec/s: 5 rss: 1139Mb L: 2/2 MS: 1 InsertByte-
    #   #5678  REDUCE cov: 504 ft: 515 corp: 3/8b lim: 4 exec/s: 10 rss: 1139Mb L: 1/2 MS: 1 ...

    if [[ ! -f "$FUZZ_LOG" ]]; then
        echo "0	0	0	0	0	0	0"
        return
    fi

    # Get the last line that starts with #<number> (a libFuzzer progress line).
    local line
    line=$(grep -E '^\s*#[0-9]+' "$FUZZ_LOG" 2>/dev/null | tail -1 || true)

    if [[ -z "$line" ]]; then
        echo "0	0	0	0	0	0	0"
        return
    fi

    local execs cov ft corp_count corp_bytes exec_s rss_mb

    # Total executions: #NNN at start of line
    execs=$(echo "$line" | grep -oE '#[0-9]+' | head -1 | tr -d '#')
    execs=${execs:-0}

    # cov: NNN
    cov=$(echo "$line" | grep -oE 'cov: [0-9]+' | grep -oE '[0-9]+')
    cov=${cov:-0}

    # ft: NNN
    ft=$(echo "$line" | grep -oE 'ft: [0-9]+' | grep -oE '[0-9]+')
    ft=${ft:-0}

    # corp: N/Nb  (count / bytes with optional unit suffix)
    local corp_str
    corp_str=$(echo "$line" | grep -oE 'corp: [0-9]+/[0-9]+[a-zA-Z]*' || true)
    if [[ -n "$corp_str" ]]; then
        corp_count=$(echo "$corp_str" | grep -oE '[0-9]+' | head -1)
        # Parse bytes with optional Kb/Mb suffix
        local raw_bytes raw_suffix
        raw_bytes=$(echo "$corp_str" | sed 's/.*\///' | grep -oE '[0-9]+')
        raw_suffix=$(echo "$corp_str" | sed 's/.*\///' | grep -oE '[a-zA-Z]+' || true)
        case "$raw_suffix" in
            Kb|kb) corp_bytes=$(( raw_bytes * 1024 )) ;;
            Mb|mb) corp_bytes=$(( raw_bytes * 1024 * 1024 )) ;;
            Gb|gb) corp_bytes=$(( raw_bytes * 1024 * 1024 * 1024 )) ;;
            *)     corp_bytes=$raw_bytes ;;
        esac
    else
        corp_count=0
        corp_bytes=0
    fi

    # exec/s: NNN
    exec_s=$(echo "$line" | grep -oE 'exec/s: [0-9]+' | grep -oE '[0-9]+')
    exec_s=${exec_s:-0}

    # rss: NNNMb
    rss_mb=$(echo "$line" | grep -oE 'rss: [0-9]+' | grep -oE '[0-9]+')
    rss_mb=${rss_mb:-0}

    echo "${execs}	${cov}	${ft}	${corp_count}	${corp_bytes}	${exec_s}	${rss_mb}"
}

# ---------------------------------------------------------------------------
# Collect crash information
# ---------------------------------------------------------------------------
collect_crashes() {
    local crashes_json="["
    local first=true

    for crash_file in "${FUZZ_DIR}"/crash-* ; do
        [[ -e "$crash_file" ]] || continue

        local basename
        basename=$(basename "$crash_file")

        local mtime
        mtime=$(stat -c '%Y' "$crash_file" 2>/dev/null || stat -f '%m' "$crash_file" 2>/dev/null || echo "0")
        local time_iso
        time_iso=$(date -d "@${mtime}" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null \
                   || date -r "${mtime}" '+%Y-%m-%dT%H:%M:%S%z' 2>/dev/null \
                   || echo "unknown")

        # Replay crash to get generated program text
        local program=""
        if command -v lake &>/dev/null; then
            program=$(cd "$FUZZ_DIR" && lake exe lean-fuzz --replay "$crash_file" 2>/dev/null || true)
        fi
        local program_json
        program_json=$(printf '%s' "$program" | json_escape)

        # Hex representation of raw crash bytes
        local hex
        hex=$(bytes_to_hex "$crash_file")
        local hex_json
        hex_json=$(printf '%s' "$hex" | json_escape)

        local basename_json
        basename_json=$(printf '%s' "$basename" | json_escape)

        local time_json
        time_json=$(printf '%s' "$time_iso" | json_escape)

        if [[ "$first" == true ]]; then
            first=false
        else
            crashes_json+=","
        fi

        crashes_json+=$(printf '{"file":%s,"time":%s,"program":%s,"bytes_hex":%s}' \
            "$basename_json" "$time_json" "$program_json" "$hex_json")
    done

    crashes_json+="]"
    echo "$crashes_json"
}

# ---------------------------------------------------------------------------
# Main collection cycle
# ---------------------------------------------------------------------------
START_TIME=""
START_EPOCH=""

collect_once() {
    ensure_dir

    local now_epoch
    now_epoch=$(date +%s)

    # Record start time on first run
    if [[ -z "$START_TIME" ]]; then
        START_TIME=$(date '+%Y-%m-%dT%H:%M:%S%z')
        START_EPOCH=$now_epoch
    fi

    local uptime=$(( now_epoch - START_EPOCH ))

    # Parse fuzzer stats
    local parsed
    parsed=$(parse_latest_line)
    IFS=$'\t' read -r execs cov ft corp_count corp_bytes exec_s rss_mb <<< "$parsed"

    # Corpus file count from disk (may differ from libFuzzer's count)
    local corpus_files=0
    if [[ -d "$CORPUS_DIR" ]]; then
        corpus_files=$(find "$CORPUS_DIR" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')
    fi

    # Crash count
    local crash_count=0
    crash_count=$(ls -1 "${FUZZ_DIR}"/crash-* 2>/dev/null | wc -l | tr -d ' ')

    # ---- stats.json ----
    cat > "${STATS_FILE}.tmp" <<EOJSON
{"execs":${execs},"coverage":${cov},"features":${ft},"corpus_count":${corpus_files},"corpus_bytes":${corp_bytes},"exec_per_sec":${exec_s},"rss_mb":${rss_mb},"crashes":${crash_count},"start_time":"${START_TIME}","uptime_seconds":${uptime}}
EOJSON
    mv "${STATS_FILE}.tmp" "$STATS_FILE"

    # ---- crashes.json ----
    local crashes_json
    crashes_json=$(collect_crashes)
    printf '%s' "$crashes_json" > "${CRASHES_FILE}.tmp"
    mv "${CRASHES_FILE}.tmp" "$CRASHES_FILE"

    # ---- plot.json (append-only) ----
    local new_point
    new_point=$(printf '{"time":%d,"execs":%s,"coverage":%s,"features":%s,"corpus":%s,"exec_per_sec":%s}' \
        "$now_epoch" "$execs" "$cov" "$ft" "$corpus_files" "$exec_s")

    if [[ -f "$PLOT_FILE" ]]; then
        # Read existing array, strip trailing ] and whitespace, append new point
        local existing
        existing=$(cat "$PLOT_FILE" 2>/dev/null || echo "[]")
        # Validate it looks like a JSON array
        if echo "$existing" | grep -qE '^\s*\['; then
            # Remove trailing ] then append
            local trimmed
            trimmed=$(echo "$existing" | sed 's/\]\s*$//')
            # Check if array is empty
            if echo "$trimmed" | grep -qE '^\s*\[\s*$'; then
                printf '%s%s]' "$trimmed" "$new_point" > "${PLOT_FILE}.tmp"
            else
                printf '%s,%s]' "$trimmed" "$new_point" > "${PLOT_FILE}.tmp"
            fi
            mv "${PLOT_FILE}.tmp" "$PLOT_FILE"
        else
            # Corrupted file, start fresh
            printf '[%s]' "$new_point" > "${PLOT_FILE}.tmp"
            mv "${PLOT_FILE}.tmp" "$PLOT_FILE"
        fi
    else
        printf '[%s]' "$new_point" > "${PLOT_FILE}.tmp"
        mv "${PLOT_FILE}.tmp" "$PLOT_FILE"
    fi

    # ---- last input (copy for dashboard) ----
    if [[ -f "$LAST_INPUT" ]]; then
        cp "$LAST_INPUT" "${API_DIR}/last-input.lean" 2>/dev/null || true
    fi

    log "execs=${execs} cov=${cov} ft=${ft} corpus=${corpus_files} crashes=${crash_count} exec/s=${exec_s} rss=${rss_mb}Mb"
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------
main() {
    log "collect-stats.sh starting (interval=${INTERVAL}s)"
    log "Watching: ${FUZZ_LOG}"
    log "Output:   ${API_DIR}/"

    if [[ "${1:-}" == "--once" ]]; then
        collect_once
        exit 0
    fi

    # Wait for the log file to appear before starting the main loop.
    if [[ ! -f "$FUZZ_LOG" ]]; then
        log "Waiting for ${FUZZ_LOG} to appear..."
        while [[ ! -f "$FUZZ_LOG" ]]; do
            sleep "$INTERVAL"
        done
        log "${FUZZ_LOG} found, beginning collection."
    fi

    # Main loop
    while true; do
        collect_once || log "WARNING: collection cycle failed, retrying next interval"
        sleep "$INTERVAL"
    done
}

main "$@"
