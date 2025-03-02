@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("OnScreenKeyboard", "PanelContainer", preload("res://text_edit_with_on_screen_keyboard.gd"), preload("res://keyboard-icon.png"))

func _exit_tree() -> void:
	remove_custom_type("OnScreenKeyboard")
