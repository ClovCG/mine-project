class_name OptionsMenu extends VBoxContainer

var menu_container: PauseMenu

@onready var controls_button: Button = $ControlsButton
@onready var back_button: Button = $BackButton

func _ready() -> void:
	menu_container = get_parent_control()
	back_button.connect("pressed", func(): menu_container.on_return_to_menu_pressed())
