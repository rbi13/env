#!/bin/sh

alias qq='transrec'
transrec(){
  working_directory="$HOME/.transrec"
  transcript_directory="$working_directory/transcripts"
  mkdir -p "$transcript_directory"
  recorded_file="$working_directory/recording.wav"
  # Generate a unique filename for the transcription
  timestamp=$(date +"%Y%m%d_%H%M%S")
  transcript_file="$transcript_directory/transcript_$timestamp.txt"
  touch "$recorded_file"
  touch "$transcript_file"
  record "$recorded_file" &&\
  transcribe "$recorded_file" "$transcript_file"
  exit 0
}

record(){
  # Record audio from a Bluetooth device
  recorded_file=$1
  device="$HEADSET_PRIMARY"
  echo "Recording audio from Bluetooth device..."
  arecord -f S16_LE -r 44100 -c 2 "$recorded_file" &
  arecord_pid=$!
  read -rp "Press Enter to stop recording..."
  echo "Stopping recording..."
  kill "$arecord_pid" 2>/dev/null
  wait "$arecord_pid" 2>/dev/null
  echo "Audio recording complete."
}

transcribe(){
  recorded_file=$1
  transcript_file=$2
  transcript=$(curl https://api.openai.com/v1/audio/transcriptions \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: multipart/form-data" \
    -F file="@$1" \
    -F model="whisper-1")

  transcript_text=$(echo "$transcript" | jq -r '.text')
  echo "$transcript_text" | cbcopy
  echo "$transcript_text" >> "$transcript_file"
}