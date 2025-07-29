# AI Photo Renamer

A macOS Finder extension that intelligently renames image files based on their visual content using OpenAI's vision capabilities.

## Features

- Right-click on images in Finder to rename them based on content analysis
- Preview suggested filenames before committing changes
- Secure API key storage using macOS Keychain
- Works with most common image formats

## Requirements

- macOS Sequoia (14.0+)
- OpenAI API key with GPT-4 Vision access

## Setup

1. Clone this repository
2. Build with Xcode 16+
3. Launch the app and enter your OpenAI API key in Settings
4. Enable the Finder extension in System Settings → Privacy & Security → Extensions

## Usage

### API Key Setup
1. Launch the app
2. Enter your OpenAI API key and click "Save to Keychain"
3. Test the functionality using the "Select Image & Preview Rename" button

### Renaming Images
Right-click on any image in Finder and select "Rename with AI" from the context menu. The file will be renamed based on its visual content.

## How It Works

The app sends your image to OpenAI's GPT-4 Vision API, which analyzes the content and returns a concise, descriptive filename. The extension handles the actual file renaming operation in Finder.

## Privacy

Your API key is stored securely in the macOS Keychain. Images are processed through the OpenAI API but are not permanently stored.
