class_name MineGrid extends GridContainer

const tile_scene: PackedScene = preload("res://Scenes/PackedScenes/Game/tile.tscn")

@export var mines: int = 10
@export var rows: int = 1

var tiles_left: int
var mine_position: Array[int] = []
var tiles: Array[Array] = []
var tiles_dict: Dictionary = {} # "mine_position": MineTile

@onready var timer: IngameTimer = $"../IngameTimer"
@onready var mines_label: Label = $"../Mines"
@onready var end_label: Label = $"../EndText"
@onready var next_level_button: Button = $"../ButtonContainer/NextLevelButton"
@onready var pause_button: PauseButton = $"../ButtonContainer/PauseButton"
@onready var pause_menu: PauseMenu = $"../PauseMenu"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset the global values and the timer
	Game.game_state = Game.GAME_STATE.LOADING
	Game.flags_used = 0
	timer.reset()
	tiles_left = rows * self.columns
	
	# Once everything is reset, set up the new grid
	mines += Game.level
	mines_label.text = Strings.LABEL_MINES % mines
	Game.flags = mines
	set_up()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_up() -> void:
	# Start preparing the field
	for row in rows:
		tiles.append([])
		for col in columns:
			var tile_pos: int = row * 10 + col
			var tile: MineTile = tile_scene.instantiate()
			self.add_child(tile)
			tile.pos = tile_pos
			tiles[row].append(0)
			# Share the right neighbor of the grid with the last tile in each row
			if col == 9:
				tile.focus_next = NodePath(pause_button.get_path())
				tile.focus_neighbor_right = NodePath(pause_button.get_path())
			tiles_dict[str(tile_pos)] = tile
	
	# Set last tilefor both previous/next and if moving to the left from the pause button
	pause_button.focus_previous = NodePath(tiles_dict["99"].get_path())
	pause_button.focus_next = NodePath(tiles_dict["99"].get_path())
	pause_button.focus_neighbor_left = NodePath(tiles_dict["99"].get_path())
	tiles_dict["0"].grab_focus()
	
	# Start setting up the mines
	for i in self.mines:
		var pos = randi_range(0, rows-1) * 10 + randi_range(0, self.columns-1)
		while pos in mine_position:
			pos = randi_range(0, rows-1) * 10 + randi_range(0, self.columns-1)
		
		var y_pos = pos / 10
		var x_pos = pos % 10
		
		set_mine_and_adjacent_numbers(x_pos, y_pos)
		mine_position.append(pos)
	
	# Finish the set up and start the game
	Game.game_state = Game.GAME_STATE.IN_PROGRESS

func set_mine_and_adjacent_numbers(x: int, y: int) -> void:
	var xy_ranges: Dictionary = Utils.get_inbounds_adjacent_ranges(x, y, rows, columns)

	# Tiles with -1 is where mines are located
	tiles[y][x] = -1
	tiles_dict[str(y * 10 + x)].num = "X"

	for x_loop in range(xy_ranges["x_min"], xy_ranges["x_max"]+1):
		for y_loop in range(xy_ranges["y_min"], xy_ranges["y_max"]+1):
			# If the adjacent tile is empty, reflect the mine's presence
			if tiles[y_loop][x_loop] != -1:
				tiles[y_loop][x_loop] += 1
				tiles_dict[str(y_loop * 10 + x_loop)].num = str(tiles[y_loop][x_loop])

func show_adjacent_tiles(x: int, y: int) -> void:
	var xy_ranges: Dictionary = Utils.get_inbounds_adjacent_ranges(x, y, rows, columns)
	
	for x_loop in range(xy_ranges["x_min"], xy_ranges["x_max"]+1):
		for y_loop in range(xy_ranges["y_min"], xy_ranges["y_max"]+1):
			if x_loop != x or y_loop != y:
				var tile_pos = y_loop * 10 + x_loop
				if not tiles_dict[str(tile_pos)].checked:
					tiles_dict[str(tile_pos)].show_tile()

# This method is called when the game ends, regardless of the result
func reveal_mines() -> void:
	timer.stopped = true
	for mine_pos in mine_position:
		tiles_dict[str(mine_pos)].show_tile()
	
	# Show the next level button and set the focus neighbors accordingly
	next_level_button.focus_previous = NodePath(tiles_dict["99"].get_path())
	next_level_button.focus_next = NodePath(pause_button.get_path())
	next_level_button.focus_neighbor_left = NodePath(tiles_dict["99"].get_path())
	next_level_button.focus_neighbor_right = NodePath(pause_button.get_path())
	pause_button.focus_previous = NodePath(next_level_button.get_path())
	pause_button.focus_neighbor_left = NodePath(next_level_button.get_path())
	next_level_button.visible = true
	end_label.visible = true
	
	if Game.game_state == Game.GAME_STATE.CLEARED:
		next_level_button.text = Strings.BUTTON_NEXTLEVEL
		pause_menu.restart_button.text = Strings.BUTTON_NEXTLEVEL
		end_label.text = Strings.LABEL_END_WIN
		return
	next_level_button.text = Strings.BUTTON_RESTART
	end_label.text = Strings.LABEL_END_LOSE
