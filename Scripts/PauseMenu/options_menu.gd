class_name OptionsMenu extends VBoxContainer

var pause_menu: PauseMenu
var controls_container: ControlsMenu

@onready var controls_button: Button = $ControlsButton
@onready var back_button: Button = $BackButton

func _ready() -> void:
	pause_menu = get_parent_control()
	controls_container = get_node_or_null("../ControlsMenu")
	back_button.connect("pressed", func(): pause_menu._on_return_to_menu_pressed())
	back_button.connect("gui_input", func(event: InputEvent): pause_menu._on_return_to_menu_input_pressed(event))

func show_options_menu() -> void:
	pause_menu.menu_container.visible = false
	self.visible = true
	controls_button.grab_focus()

# SIGNAL METHODS #
func _on_controls_pressed() -> void:
	controls_container.show_controls_menu()

func _on_controls_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, Strings.INPUT_ACTION_ACCEPT) and event.is_pressed() and event is not InputEventMouseButton:
		controls_container.show_controls_menu()

func _on_return_to_options_pressed() -> void:
	controls_container.visible = false
	self.visible = true
	controls_button.grab_focus()

func _on_return_to_options_input_pressed(event: InputEvent) -> void:
	if InputMap.event_is_action(event, Strings.INPUT_ACTION_ACCEPT) and event.is_pressed() and event is not InputEventMouseButton:
		controls_container.visible = false
		self.visible = true
		controls_button.grab_focus()
