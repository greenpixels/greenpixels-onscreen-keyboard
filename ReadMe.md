# Greenpixels OnScreen Keyboard for Godot

## Overview
`Greenpixels-OnScreen-Keyboard` is a Godot `@tool` plugin for an on-screen keyboard designed to be **controller- and touch-accessible**. It provides a virtual keyboard UI for touchscreen or gamepad input.

## Features
- QWERTY layout
- Emits signals for text changes, cancel and submit actions.
- Works with controllers and touchscreens
- Keyboard can be hidden

![](.github/screenshot1.png)
![](.github/screenshot2.png)
![](.github/screenshot3.png)
## Usage
> 🛈 This repository can be added as a Git submodule:
> `git submodule add https://github.com/greenpixels/greenpixels-onscreen-keyboard.git addons/greenpixels-onscreen-keyboard`

To use the component, just add a child-scene of `text_edit_with_on_screen_keyboard` to your scene.

## API
- **Signals**: 
  - `on_text_changed(text : String)`
  - `on_cancel_pressed()`
  - `on_submit_pressed(text: String)`
- **Inspector Toggles**:
  - `text_placeholder` : `String`
  - `show_input` : `bool`
  - `show_keyboard` : `bool`
  - `show_cancel_button` : `bool`
  - `show_submit_button` : `bool`
  - `only_show_numbers` : `bool`
  - `show_space` : `bool`
  - `show_shift` : `bool`
  - `show_backspace` : `bool`
  - `show_symbols` : `bool`

## Credits:
Keyboard Icon - by https://fontawesome.com/
