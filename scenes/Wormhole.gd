extends Node2D

export(int) var num_rings = 20
export(float) var advancing_period = 1
export(float) var radius_increase_factor = 1.35
export(float) var initial_radius = 8
export(int) var ring_index = 14

onready var ring_scene : PackedScene = preload("res://scenes/Ring.tscn")

onready var center : Position2D = $Center
onready var ring_container : Node2D = $RingContainer
onready var advancing_timer : Timer = $AdvancingTimer
onready var player = $Player
onready var score_label = $Score/Value
onready var background = $Background
onready var color_tween = $Background/ColorTween

var rings : Array = []
var advancing : bool = false
var level : int = 1
var player_angle : float = 180
var game_over : bool = false
var can_restart : bool = false
var score : int = 0 setget set_score
var highscore : int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	# hide gameover screen
	$GameOver.visible = false
	can_restart = false
	
	# initial background color
	background.modulate = rand_color(10.0/255, 40.0/255)
	
	# load highscore
	highscore = save_system.load_score()
	if highscore > 0:
		$Highscore.visible = true
		$Highscore/Value.text = str(highscore)
	
	# center elements in the middle of the screen
	var rect = get_viewport().get_visible_rect()
	var center_position = rect.position + rect.size / 2
	$Center.global_position = center_position
	$Stars.global_position = center_position
	
	var radius = initial_radius
	for i in range(num_rings):
		# create ring instances
		# first ring after the ring the player starts on should be empty,
		# but not fixed, otherwise the player might be spawned with a bomb
		# on the next position and with no possibility to dodge it
		var instance = generate_ring(ring_index <= i + 1, ring_index <= i)
		instance.radius = radius
		radius *= radius_increase_factor
		
		# add rings to the scene
		rings.push_back(instance)
		ring_container.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# while advancing ignore everything
	if advancing:
		return
	
	# calculate angle position of player and update angle position
	var curr_ring = rings[ring_index]
	if curr_ring.rotating:
		player_angle += delta * curr_ring.ring_rotation_ps
		var relative_position : Vector2 = curr_ring.calculate_position_on_ring(player_angle)
		player.global_position = center.global_position + relative_position
	
	# advance on key pressed
	if Input.is_action_just_pressed("advance") and not game_over:
		advancing = true
		advance()
	
	if Input.is_action_just_pressed("advance") and can_restart:
		get_tree().reload_current_scene()

func advance():
	# add points to score according to the level
	set_score(score + 1 + level / 10)
	
	# increment level
	level += 1
	
	# remove a ring if the desired number is reached
	if rings.size() >= num_rings:
		ring_container.remove_child(rings.pop_back())
	
	# start a radius increase transition
	for ring in rings:
		ring.increase_radius(ring.radius * radius_increase_factor, advancing_period)
	advancing_timer.start(advancing_period)
	player.toggle_thrusters(true)
	
	# add a new ring to the scene
	var instance = generate_ring()
	instance.radius = initial_radius
	rings.push_front(instance)
	ring_container.add_child(instance)
	toggle_rings_rotation(false)


func generate_ring(empty : bool = false, fixed : bool = false) -> Node2D:
	# create new instance
	var instance = ring_scene.instance()
	instance.global_position = center.global_position
	
	if not empty:
		# randomly populate the ring with bombs
		var num_bombs = level / 25 + round(rand_range(0, level / 50 + 2))
		var bombs = []
		for _i in range(num_bombs):
			bombs += [randi() % 360]
		instance.create_bombs(bombs)
		
		# randomly populate the ring with coins
		var num_coins = round(rand_range(0, 3))
		var coins = []
		for _i in range(num_coins):
			coins += [randi() % 360]
		instance.create_coins(coins)
		
		# randomly populate the ring with walls
		var num_walls = round(rand_range(1, 2))
		var walls : Dictionary = {}
		for _i in range(num_walls):
			var pos = randi() % 360
			walls[pos] = pos + 20
		instance.create_walls(walls)
	
	if not fixed:
		# randomly set rotation speed and direction
		var max_rotation_speed = 60 + level
		var min_rotation_speed = 30
		var rotation_direction_sign = 1 if randi() % 2 == 0 else -1
		instance.ring_rotation_ps = rotation_direction_sign * rand_range(min_rotation_speed, max_rotation_speed)
	
	# return configurated instance
	return instance


func set_score(new_score : int):
	score = new_score
	score_label.text = str(score)


func _on_AdvancingTimer_timeout():
	advancing = false
	player.toggle_thrusters(false)
	if not game_over:
		toggle_rings_rotation(true)


func toggle_rings_rotation(active : bool):
	for ring in rings:
		ring.rotating = active


func _on_Player_died():
	game_over = true
	toggle_rings_rotation(false)
	player.toggle_thrusters(false)


func _on_Player_game_over():
	var game_over_label_text = "Score:"
	if score > highscore:
		save_system.save_score(score)
		game_over_label_text = "New high score:"
	$GameOver/ScoreLabel.text = game_over_label_text
	$GameOver/ScoreLabel/Value.text = str(score)
	$GameOver.visible = true
	can_restart = true


func _on_Player_collected_coin():
	set_score(score + 1 + level / 20)


func _on_ColorTimer_timeout():
	var next_color : Color = rand_color(10.0/255, 40.0/255)
	color_tween.interpolate_property(background, "modulate", background.modulate, next_color, 1.2)
	color_tween.start()


func rand_color(start_interval : float = 0, end_interval : float = 1) -> Color:
	return Color(
		rand_range(start_interval, end_interval),
		rand_range(start_interval, end_interval),
		rand_range(start_interval, end_interval))
