class_name MineTile extends ColorRect

var grid: MineGrid
var pos: int = 0
var num: String = ""
var flagged: bool = false
var checked: bool = false

@onready var label: Label = $Label
@onready var outline: ReferenceRect = $ReferenceRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid = get_parent_control()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	outline.visible = self.has_focus()

# SIGNAL METHODS #
func _on_mouse_entered() -> void:
	outline.visible = true
	self.grab_focus()

func _on_mouse_exited() -> void:
	outline.visible = false


func _on_tile_pressed(event: InputEvent) -> void:
	if Game.game_state == Game.GAME_STATE.IN_PROGRESS and event.is_pressed() and not checked:
		# Shows the content of the tile as long as there's no flag
		if InputMap.event_is_action(event, Strings.INPUT_ACTION_ACCEPT) and not flagged:
			show_tile()
		# Puts/Removes a flag on the tile
		elif InputMap.event_is_action(event, Strings.INPUT_ACTION_SETFLAG):
			if not flagged and Game.flags_used < Game.flags:
				self.flagged = true
				Game.flags_used += 1
				label.text = "?"
			elif flagged and Game.flags_used > 0:
				self.flagged = false
				Game.flags_used -= 1
				label.text = ""

# Shows the content of the tile
func show_tile() -> void:
	self.checked = true
	label.text = self.num

	if Game.game_state == Game.GAME_STATE.IN_PROGRESS:
		self.color = Color(Strings.COLOR_DARKGRAY)
		grid.tiles_left -= 1
		match num:
			# Tile has a mine --> Game Over
			"X":
				Game.game_state = Game.GAME_STATE.LOST
				Game.level = 0
				grid.reveal_mines()
			# Tile is empty --> Show the adjacent tiles too
			"":
				grid.show_adjacent_tiles(self.pos % 10, self.pos / 10)
		
		# Last condition avoids the win when mine is hit with 2 tiles left
		if grid.tiles_left == grid.mines and Game.game_state != Game.GAME_STATE.LOST:
			Game.game_state = Game.GAME_STATE.CLEARED
			grid.reveal_mines()
	
	# The conditions below are only true when the game is finished
	elif Game.game_state == Game.GAME_STATE.LOST:
		self.color = Color(Strings.COLOR_RED)
	else:
		self.color = Color(Strings.COLOR_BLUE)
		label.text = "!"
