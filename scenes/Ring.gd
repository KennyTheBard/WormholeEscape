extends Node2D

export(int) var point_count = 10000
export(float) var scaling_factor = 0.0035
export(float) var wall_scaling_factor = 0.00075

onready var radius_tween : Tween = $RadiusTween
onready var bomb_container : Node2D = $BombContainer
onready var coin_container : Node2D = $CoinContainer
onready var wall_container : Node2D = $WallContainer

const bomb_scene = preload("res://scenes/Bomb.tscn")
const coin_scene = preload("res://scenes/Coin.tscn")
const wall_scene = preload("res://scenes/Wall.tscn")

var radius : float = 8 setget set_radius
var ring_rotation : float = 0
var ring_rotation_ps : float = 0
var rotating : bool = true

var bombs : Array = []
var coins : Array = []
var walls : Array = []


func _ready():
	# migrate bombs from scrip memory to the scene tree
	for bomb in bombs:
		bomb_container.add_child(bomb)
	bombs = []
	
	# migrate coins from scrip memory to the scene tree
	for coin in coins:
		coin_container.add_child(coin)
	coins = []
	
	# migrate walls from scrip memory to the scene tree
	for wall in walls:
		wall_container.add_child(wall)
	walls = []
	
	# make an initial update
	update_props()


func _process(delta):
	if rotating:
		ring_rotation += delta * ring_rotation_ps
		for wall in wall_container.get_children():
			wall.angle_on_ring -= delta * ring_rotation_ps
			wall.rotation -= deg2rad(delta * ring_rotation_ps)
	update()


func _draw():
	draw_arc(Vector2(), radius, 0, 360, point_count, Color.white, 1, true)


func create_bombs(bomb_positions : Array):
	for pos in bomb_positions:
		var instance = bomb_scene.instance()
		instance.angle_on_ring = pos
		bombs.append(instance)


func create_coins(coin_positions : Array):
	for pos in coin_positions:
		var instance = coin_scene.instance()
		instance.angle_on_ring = pos
		coins.append(instance)


func create_walls(wall_intervals : Dictionary):
	for start_pos in wall_intervals.keys():
		var end_pos : float = wall_intervals[start_pos]
		for pos in range(start_pos, end_pos, 3):
			var instance = wall_scene.instance()
			instance.angle_on_ring = pos
			walls.append(instance)


func calculate_position_on_ring(degree : float) -> Vector2:
	var radians = deg2rad(degree)
	return Vector2(cos(radians), -sin(radians)) * radius


func increase_radius(radius : float, transition_period : float = 1.0) -> void:
	radius_tween.interpolate_property(self, "radius", self.radius, radius,
		transition_period, Tween.TRANS_QUAD, Tween.EASE_IN)
	radius_tween.start()


func set_radius(new_radius : float):
	radius = new_radius
	update_props()


func update_props():
	# make sure to only execute if the node is inside the scene tree
	if is_inside_tree():
		# update each bomb
		for bomb in bomb_container.get_children():
			bomb.position = calculate_position_on_ring(bomb.angle_on_ring)
			bomb.scale = Vector2(radius * scaling_factor, radius * scaling_factor)
			
		# update each coin
		for coin in coin_container.get_children():
			coin.position = calculate_position_on_ring(coin.angle_on_ring)
			coin.scale = Vector2(radius * scaling_factor, radius * scaling_factor)
		
		# update each wall
		for wall in wall_container.get_children():
			wall.wall.position = calculate_position_on_ring(-wall.angle_on_ring)
			wall.rotation = 0
			wall.wall.scale = Vector2(radius * wall_scaling_factor, radius * wall_scaling_factor)
