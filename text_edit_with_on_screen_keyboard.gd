@tool
extends PanelContainer
class_name OnScreenKeyboard

const BIG_LETTERS_NODE_NAME := "LettersBig"
const SMALL_LETTERS_NODE_NAME := "LettersSmall"
const SYMBOLS_NODE_NAME := "Symbols"

@export var show_keyboard := true :
	set(value):
		show_keyboard = value
		%Controls.visible = show_keyboard

@export var show_cancel_button := true :
	set(value):
		show_cancel_button = value
		%CancelButton.visible = show_cancel_button
		%MetaButtons.visible = (%CancelButton.visible or %SubmitButton.visible)
		
@export var show_submit_button := true :
	set(value):
		show_submit_button = value
		%SubmitButton.visible = show_submit_button
		%MetaButtons.visible = (%CancelButton.visible or %SubmitButton.visible)
		
@onready var keyboards := %Keyboards
@onready var text_edit := %TextEdit

signal on_text_changed(text: String)
signal on_cancel_pressed
signal on_submit_pressed(text: String)

func _ready() -> void:
	if not Engine.is_editor_hint():
		for key in %NumberKeys.get_children():
			key.pressed.connect(func(): handle_key_pressed(key))
		for keyboard in keyboards.get_children():
			for grid in keyboard.get_children():
				if not grid is GridContainer: continue
				for key in grid.get_children():
					if key is Button:
						key.pressed.connect(func(): handle_key_pressed(key))
			
func handle_key_pressed(key: Button):
	text_edit.text += key.text
	on_text_changed.emit(text_edit.text)

func _on_submit_button_pressed() -> void:
	on_submit_pressed.emit(text_edit.text)

func _on_cancel_button_pressed() -> void:
	on_cancel_pressed.emit()

func _on_shift_button_pressed() -> void:
	for keyboard in keyboards.get_children() as Array[TabContainer]:
		if not keyboard.is_visible_in_tree(): continue
		var big_letter_node : GridContainer = keyboard.find_child(BIG_LETTERS_NODE_NAME, false, true)
		var small_letter_node : GridContainer = keyboard.find_child(SMALL_LETTERS_NODE_NAME, false, true)
		if big_letter_node.is_visible_in_tree():
			small_letter_node.visible = true
		else:
			big_letter_node.visible = true
		break

func _on_symbols_button_pressed() -> void:
	for keyboard in keyboards.get_children() as Array[TabContainer]:
		if not keyboard.is_visible_in_tree(): continue
		var symbols_node : GridContainer = keyboard.find_child(SYMBOLS_NODE_NAME, false, true)
		symbols_node.visible = true

func _on_space_button_pressed() -> void:
	text_edit.text += " "
	on_text_changed.emit(text_edit.text)

func _on_backspace_button_pressed() -> void:
	var current_text : String = text_edit.text
	if current_text.length() <= 0: return
	text_edit.text = current_text.substr(0, current_text.length() - 1)
	on_text_changed.emit(text_edit.text)


func _on_keyboard_button_pressed() -> void:
	show_keyboard = !show_keyboard
