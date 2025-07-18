class_name MineGrid extends GridContainer

const tile_scene: PackedScene = preload("res://Scenes/PackedScenes/tile.tscn")

@export var mines: int = 10
@export var rows: int = 1

var tiles_left: int
var mine_position: Array[int] = []
var tiles: Array[Array] = []
var tiles_dict: Dictionary = {} # "mine_position": MineTile

@onready var timer: IngameTimer = $"../IngameTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset the global values and the timer
	Game.game_state = Game.GAME_STATE.LOADING
	Game.flags_used = 0
	timer.reset()
	tiles_left = rows * self.columns
	
	# Once everything is reset, set up the new grid
	mines += Game.level
	Game.flags = mines
	set_up()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventKey:
		if InputMap.event_is_action(event, "start"):
			Game.restart()

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
			tiles_dict[str(tile_pos)] = tile
	
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
	timer.stop()
	for mine_pos in mine_position:
		tiles_dict[str(mine_pos)].show_tile()
