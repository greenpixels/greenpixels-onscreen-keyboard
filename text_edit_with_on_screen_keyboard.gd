@tool
extends PanelContainer
class_name OnScreenKeyboard

const BIG_LETTERS_NODE_NAME := "LettersBig"
const SMALL_LETTERS_NODE_NAME := "LettersSmall"
const SYMBOLS_NODE_NAME := "Symbols"

@onready var keyboards := %Keyboards
@onready var text_edit : TextEdit= %TextEdit

@export var text_placeholder : String = "Input text ..." :
	set(value):
		if not is_node_ready():
			await ready
		text_placeholder = value
		text_edit.placeholder_text = text_placeholder

@export var show_input := true :
	set(value):
		if not is_node_ready():
			await ready
		show_input = value
		%TextInputContainer.visible = show_input

@export var show_keyboard := true :
	set(value):
		if not is_node_ready():
			await ready
		show_keyboard = value
		%Controls.visible = show_keyboard

@export var show_cancel_button := true :
	set(value):
		if not is_node_ready():
			await ready
		show_cancel_button = value
		%CancelButton.visible = show_cancel_button
		%MetaButtons.visible = (%CancelButton.visible or %SubmitButton.visible)
		
@export var show_submit_button := true :
	set(value):
		if not is_node_ready():
			await ready
		show_submit_button = value
		%SubmitButton.visible = show_submit_button
		%MetaButtons.visible = (%CancelButton.visible or %SubmitButton.visible)
		
@export var only_show_numbers := false :
	set(value):
		if not is_node_ready():
			await ready
		only_show_numbers = value
		keyboards.visible = !only_show_numbers

@export var show_space := true :
	set(value):
		if not is_node_ready():
			await ready
		show_space = value
		%SpaceButton.visible = show_space
		
@export var show_shift := true :
	set(value):
		if not is_node_ready():
			await ready
		show_shift = value
		%ShiftButton.visible = show_shift

@export var show_backspace := true :
	set(value):
		if not is_node_ready():
			await ready
		show_backspace = value
		%BackspaceButton.visible = show_backspace

@export var show_symbols := true :
	set(value):
		if not is_node_ready():
			await ready
		show_symbols = value
		%SymbolsButton.visible = show_symbols

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
		text_edit.text_changed.connect(handle_text_change)

func handle_text_change():
	var caret_column = text_edit.get_caret_column()
	if only_show_numbers:
		# Remove all characters that are not a number, but don't be limited to the MAX_INT
		# Remeber that is_digit is not the same as is_number
		for character in text_edit.text:
			if not character.is_valid_int():
				text_edit.text = text_edit.text.replace(character, "")
	if not show_space:
		text_edit.text = text_edit.text.replace(" ", "")
	if not show_symbols:
		text_edit.text = text_edit.text.replace("!", "")
		text_edit.text = text_edit.text.replace("@", "")
		text_edit.text = text_edit.text.replace("#", "")
		text_edit.text = text_edit.text.replace("$", "")
		text_edit.text = text_edit.text.replace("%", "")
		text_edit.text = text_edit.text.replace("^", "")
		text_edit.text = text_edit.text.replace("&", "")
		text_edit.text = text_edit.text.replace("*", "")
		text_edit.text = text_edit.text.replace("(", "")
		text_edit.text = text_edit.text.replace(")", "")
		text_edit.text = text_edit.text.replace("-", "")
		text_edit.text = text_edit.text.replace("_", "")
		text_edit.text = text_edit.text.replace("+", "")
		text_edit.text = text_edit.text.replace("=", "")
		text_edit.text = text_edit.text.replace("{", "")
		text_edit.text = text_edit.text.replace("}", "")
		text_edit.text = text_edit.text.replace("[", "")
		text_edit.text = text_edit.text.replace("]", "")
		text_edit.text = text_edit.text.replace("|", "")
		text_edit.text = text_edit.text.replace(":", "")
		text_edit.text = text_edit.text.replace(";", "")
		text_edit.text = text_edit.text.replace("'", "")
		text_edit.text = text_edit.text.replace('"', "")
		text_edit.text = text_edit.text.replace("<", "")
		text_edit.text = text_edit.text.replace(">", "")
		text_edit.text = text_edit.text.replace(",", "")
		text_edit.text = text_edit.text.replace(".", "")
		text_edit.text = text_edit.text.replace("?", "")
		text_edit.text = text_edit.text.replace("/", "")
		text_edit.text = text_edit.text.replace("`", "")
		text_edit.text = text_edit.text.replace("~", "")
		text_edit.text = text_edit.text.replace(" ", "")
		text_edit.text = text_edit.text.replace("\\", "")
	text_edit.set_caret_column(caret_column)
	on_text_changed.emit(text_edit.text)
			
func handle_key_pressed(key: Button):
	text_edit.text += key.text
	handle_text_change()

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
	handle_text_change()

func _on_backspace_button_pressed() -> void:
	var current_text : String = text_edit.text
	if current_text.length() <= 0: return
	text_edit.text = current_text.substr(0, current_text.length() - 1)
	handle_text_change()


func _on_keyboard_button_pressed() -> void:
	show_keyboard = !show_keyboard
