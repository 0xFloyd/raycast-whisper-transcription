# Whisper Transcription for Raycast

A Raycast extension that uses OpenAI's Whisper model for speech-to-text transcription, powered by [whisper.cpp](https://github.com/ggerganov/whisper.cpp) by [Georgi Gerganov](https://x.com/ggerganov).

## Features

- Start/stop audio recording with customizable hotkeys (default: Cmd+T)
- High-performance speech recognition using whisper.cpp
- Optimized for Apple Silicon
- Supports various audio formats via FFmpeg

## Prerequisites

- [Raycast](https://www.raycast.com/)
- [FFmpeg](https://ffmpeg.org/)
- [whisper.cpp](https://github.com/ggerganov/whisper.cpp)

## Installation

1. Clone this repository:

   ```
   git clone https://github.com/yourusername/raycast-whisper-transcription.git
   ```

2. Install FFmpeg:

   ```
   brew install ffmpeg
   ```

3. Set up whisper.cpp:

   ```
   git clone https://github.com/ggerganov/whisper.cpp.git
   cd whisper.cpp
   make
   bash ./models/download-ggml-model.sh base.en
   ```

4. Add the extension to Raycast:

   - Open Raycast
   - Go to Extensions > Script Commands
   - Click the "+" button and select "Add Script Directory"
   - Choose the directory containing this extension

5. Set up the hotkey:
   - In Raycast, go to Extensions > Script Commands
   - Find the Whisper Transcription command
   - Click on it and assign your desired hotkey (e.g., Cmd+T)

## Environment Setup

After installation, you need to set up the environment variables. Copy the `.env.example` file to a new file named `.env` and fill in the following variables:

1. Copy the example file:

   ```
   cp .env.example .env
   ```

2. Edit the `.env` file and set the following variables:

   ```
   RAYCAST_SCRIPT_DIR=/path/to/your/raycast/extension/directory
   WHISPER_DIR=/path/to/whisper.cpp/main
   WHISPER_MODEL=/path/to/whisper.cpp/models/ggml-base.en.bin
   ```

   Replace the paths with the actual locations on your system:

   - `RAYCAST_SCRIPT_DIR`: The directory where this Raycast extension is located
   - `WHISPER_DIR`: The directory containing the whisper.cpp `main` executable (typically `/path/to/whisper.cpp/main`)
   - `WHISPER_MODEL`: The full path to the Whisper model file (typically `/path/to/whisper.cpp/models/ggml-base.en.bin`)

Ensure that these paths are correct for your system setup. The extension will use these variables to locate the necessary files and directories.

## Usage

1. Press Cmd+T (or your custom hotkey) to start recording audio
2. Press Cmd+T again to stop recording and start transcription
3. The transcribed text will appear in Raycast

## How It Works

This extension leverages the high-performance C/C++ implementation of OpenAI's Whisper model provided by whisper.cpp. Key features include:

- Plain C/C++ implementation without dependencies
- Optimized for Apple Silicon via ARM NEON, Accelerate framework, Metal, and Core ML
- Mixed F16 / F32 precision
- 4-bit and 5-bit integer quantization support
- Zero memory allocations at runtime
- CPU and GPU inference support

## License

MIT

## Acknowledgements

- [whisper.cpp](https://github.com/ggerganov/whisper.cpp) by [Georgi Gerganov](https://x.com/ggerganov)
- [OpenAI Whisper](https://github.com/openai/whisper)
- [Raycast](https://www.raycast.com/)
- [FFmpeg](https://ffmpeg.org/)
