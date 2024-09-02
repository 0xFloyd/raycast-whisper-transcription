#!/bin/bash  

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Transcribe and Paste 
# @raycast.mode silent 

# Optional parameters:
# @raycast.icon 🔉 

# Documentation:
# @raycast.author 0xfloyd
# @raycast.authorURL https://raycast.com/0xfloyd 

# Source the .env file
if [ -f "$(dirname "$0")/.env" ]; then
    source "$(dirname "$0")/.env"
else
    echo ".env file not found" >&2
    exit 1
fi

# Define the directory paths
SCRIPT_DIR="${RAYCAST_SCRIPT_DIR}"
PAST_DIR="$SCRIPT_DIR/past"
lockfile="$PAST_DIR/transcribe_and_paste.lock"
pid_file="$PAST_DIR/ffmpeg.pid"
debug_log="$PAST_DIR/debug.log"

log_debug() {
    echo "$(date): $1" >> "$debug_log"
}


# Function to transcribe and paste the audio
transcribe_and_paste() {
    local output_file="$1"
    date_str=$(date +"%Y-%m-%d_%H-%M-%S")
    output_txt="$PAST_DIR/transcription_$date_str.txt"

    log_debug "Transcribe and paste started. Output file: $output_file"

    if [ ! -f "$output_file" ]; then
        log_debug "No recording found at $output_file"
        echo "No recording found" > "$output_txt"
        echo "No recording found" | grep . >&2
        return
    fi

    log_debug "Recording file exists. Size: $(wc -c < "$output_file") bytes"

    transcription=$("${WHISPER_DIR}/main" -m "${WHISPER_MODEL}" --no-timestamps -f "$output_file" 2>/dev/null)    transcription_exit_code=$?

    log_debug "Transcription complete. Exit code: $transcription_exit_code"

    if [ $transcription_exit_code -ne 0 ]; then
        log_debug "Transcription failed. Error: $transcription"
        echo "Transcription failed. Error: $transcription" > "$output_txt"
        echo "Transcription failed" | grep . >&2
        return
    fi

    cleaned_transcription=$(echo "$transcription" | grep -v '^\[' | grep -v '^whisper_' | grep -v '^system_info:' | grep -v '^main:' | grep -v '^ggml_' | sed -e 's/^[[:space:]]*//' | tr -s ' ' | sed '/^$/d')

    if [ -n "$cleaned_transcription" ]; then
        echo "$cleaned_transcription" > "$output_txt"
        osascript -e "set the clipboard to \"$cleaned_transcription\""
        sleep 0.1
        osascript -e 'tell application "System Events" to keystroke "v" using command down'
        log_debug "Transcription pasted and saved to $output_txt"
        echo "Transcription pasted and saved to $output_txt" | grep . >&2
    else
        log_debug "Transcription empty"
        echo "Transcription empty" > "$output_txt"
        echo "Transcription empty" | grep . >&2
    fi

    echo "SUCCESS" | grep . >&2
}

start_recording() {
    output_file="$PAST_DIR/recording.wav"
    log_debug "Starting recording to $output_file"
    ffmpeg -y -f avfoundation -i ":0" -t 60 "$output_file" 2>> "$debug_log" & echo $! > "$pid_file"
    echo "Recording started" | grep . >&2
    touch "$lockfile"
}


stop_recording() {
    log_debug "Stopping recording"
    if [ -f "$pid_file" ]; then
        kill $(cat "$pid_file")
        rm "$pid_file"
    fi
    echo "Recording stopped" | grep . >&2
    rm -f "$lockfile"

    output_file="$PAST_DIR/recording.wav"
    transcribe_and_paste "$output_file"
    rm -f "$output_file"
}



mkdir -p "$PAST_DIR"

log_debug "Script started. Lockfile status: $([ -f "$lockfile" ] && echo "exists" || echo "does not exist")"


if [ -f "$lockfile" ]; then
    stop_recording
else
    start_recording
fi

log_debug "Script ended"