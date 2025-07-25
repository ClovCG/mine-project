class_name PauseMenu extends Control

var prev_focus_node: Control
var prev_game_state: int

@onready var menu_container: VBoxContainer = $PauseMenu_Main
@onready var options_container: OptionsMenu = $OptionsMenu
@onready var controls_container: ControlsMenu = $ControlsMenu

@onready var continue_button: Button = $PauseMenu_Main/ContinueButton
@onready var restart_button: Button = $PauseMenu_Main/RestartButton
@onready var options_button: Button = $PauseMenu_Main/OptionsButton
@onready var quit_button: Button = $PauseMenu_Main/QuitButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# Handles menu pause from keyboard/gamepad inputs
	if event.is_action_pressed("start") and self.visible:
		hide_pause_menu()
	elif event.is_action_pressed("start") and !self.visible:
		show_pause_menu()

func show_pause_menu() -> void:
	prev_game_state = Game.game_state
	Game.update_game_state(Game.GAME_STATE.PAUSED)
	self.visible = true
	menu_container.visible = true
	# Gets the current node with focus so it's returned to it after pressing continue
	prev_focus_node = get_viewport().gui_get_focus_owner()
	continue_button.grab_focus()

func hide_pause_menu() -> void:
	# Returns the focus to the previous owner before opening the pause menu
	prev_focus_node.grab_focus()
	Game.update_game_state(prev_game_state)
	options_container.visible = false
	controls_container.visible = false
	self.visible = false

func show_options_menu() -> void:
	menu_container.visible = false
	options_container.visible = true
	options_container.back_button.grab_focus()

# SIGNAL METHODS #
func _on_continue_pressed() -> void:
	hide_pause_menu()

func _on_continue_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		hide_pause_menu()


func _on_restart_pressed() -> void:
	Game.restart()

func _on_restart_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		Game.restart()


func _on_options_pressed() -> void:
	options_container.show_options_menu()

func _on_options_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		options_container.show_options_menu()

func _on_return_to_menu_pressed() -> void:
	options_container.visible = false
	menu_container.visible = true
	options_button.grab_focus()

func _on_return_to_menu_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		options_container.visible = false
		menu_container.visible = true
		options_button.grab_focus()


func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_quit_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, "accept") and event.is_pressed():
		get_tree().quit()
