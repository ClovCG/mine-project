class_name ControlsMenu extends TabContainer

var options_container: OptionsMenu

@onready var controls_container: PanelContainer = $Controls
@onready var howtoplay_container: RichTextLabel = $HowToPlay
@onready var back_button: Button = $Node2D/BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_container = get_node_or_null("../OptionsMenu")
	set_tab_title(0, Strings.CONTROLS_MENU_CONTROLS_TAB)
	set_tab_title(1, Strings.CONTROLS_MENU_HOWTOPLAY_TAB)
	back_button.connect("pressed", func(): options_container._on_return_to_options_pressed())
	back_button.connect("gui_input", func(event: InputEvent): options_container._on_return_to_options_input_pressed(event))

func show_controls_menu() -> void:
	options_container.visible = false
	self.visible = true
	self.get_tab_bar().grab_focus()
