class_name MineTile extends ColorRect

@onready var label: Label = $Label
var grid: MineGrid

var pos: int = 0
var num: String = ""
var flagged: bool = false
var checked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid = get_parent_control()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

# TODO: Modify inputs to allow gamepads as well
func _on_tile_pressed(event: InputEvent) -> void:
	if Game.game_state == Game.GAME_STATE.IN_PROGRESS and event is InputEventMouseButton and event.is_pressed() and not checked:
		match event.button_index:
			# Shows the content of the tile as long as there's no flag
			MOUSE_BUTTON_LEFT:
				if not flagged:
					show_tile()
			# Puts/Removes a flag on the tile
			MOUSE_BUTTON_RIGHT:
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
		self.color = Color("3b3b3b")
		grid.tiles_left -= 1
		match num:
			# Tile has a mine --> Game Over
			"X":
				Game.game_state = Game.GAME_STATE.LOST
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
		self.color = Color("C64500")
	else:
		self.color = Color("208ab3")
		label.text = "!"
