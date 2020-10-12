extends Node2D

export(int) var num_rings = 20
export(float) var advancing_period = 1
export(float) var radius_increase_factor = 1.35
export(float) var initial_radius = 8
export(float) var minimum_distance = 25
export(float) var attackers_speed = 0.1
export(float) var attackers_acc = 0.1
export(int) var player_ring_index = 14

onready var ring_scene : PackedScene = preload("res://scenes/Ring.tscn")
onready var menu_scene : PackedScene = load("res://menu/Menu.tscn")

onready var center : Position2D = $Center
onready var ring_container : Node2D = $RingContainer
onready var advancing_timer : Timer = $Misc/AdvancingTimer
onready var player = $Player
onready var score_label = $GUI/Score/Value
onready var background = $Background
onready var color_tween = $Background/ColorTween

var rings : Array = []
var advancing : bool = false
var ready_to_start : bool = false
var level : int = 1
var player_angle : float = 180
var game_over : bool = false
var can_restart : bool = false
var paused : bool = false
var mouse_over_button : bool = false
var score : int = 0
var highscore : int = 0
var attackers_distance : float = -3

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide gameover screen
	$GUI/GameOver.visible = false
	$GUI/Paused.visible = false
	can_restart = false
	
	# initial background color
	background.modulate = rand_color(10.0/255, 40.0/255)
	
	# load highscore
	highscore = save_system.load_score()
	if highscore > 0:
		$GUI/Highscore.visible = true
		$GUI/Highscore/Value.text = str(highscore)
	
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
		var instance = generate_ring(player_ring_index <= i + 1, player_ring_index <= i)
		instance.radius = radius
		radius *= radius_increase_factor
		
		# add rings to the scene
		rings.push_back(instance)
		ring_container.add_child(instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if game_over:
		# restart
		if Input.is_action_just_pressed("advance") and can_restart:
			get_tree().reload_current_scene()
		return
		
	# update attacked rings
	update_attackers_location()
	for ring_index in range(player_ring_index, num_rings):
		var current_index = ring_index - player_ring_index
		var attacker_factor = current_index + attackers_distance
		rings[ring_index].set_attacker_factor(min(1, max(0, attacker_factor)))
		if current_index == 0 and attacker_factor >= 1:
			player.die()
			
	# ignore action when the mouse is over pause button
	# (otherwise the next block will close pause menu)
	# and ignore action before the game is ready
	# (otherwise a leftover input action could trigger the first advance)
	if Input.is_action_just_pressed("advance") and (mouse_over_button or not ready_to_start):
		return
	
	# resume from pause
	if Input.is_action_just_pressed("advance") and paused:
		paused = false
		toggle_rings_rotation(true)
		$GUI/Paused.visible = false
		return
	
	# while advancing ignore everything
	if advancing or paused:
		return
	
	# calculate angle position of player and update angle position
	var curr_ring = rings[player_ring_index]
	if curr_ring.rotating:
		player_angle += delta * curr_ring.ring_rotation_ps
		var relative_position : Vector2 = curr_ring.calculate_position_on_ring(player_angle)
		player.global_position = center.global_position + relative_position
	
	# update attackers
	attackers_distance += attackers_speed * delta
	attackers_speed += attackers_acc * delta * settings.get_difficulty_modifier()
	$GUI/AttackersDistance.value = attackers_distance + 20
	
	# advance on key pressed
	if Input.is_action_just_pressed("advance"):
		advancing = true
		advance()


func update_attackers_location():
	for attacker in $AttackersContainer.get_children():
		var next_ring = rings[player_ring_index - ceil(max(-3, attackers_distance)) + 1]
		var prev_ring = rings[player_ring_index - floor(max(-3, attackers_distance)) + 1]
		var alpha = attackers_distance - floor(attackers_distance)
		var dif_vector = attacker.attacker_position - attacker.look_to.global_position
		var prev_pos = dif_vector.normalized() * (prev_ring.radius + attacker.variation)
		var next_pos = dif_vector.normalized() * (next_ring.radius + attacker.variation)
		print(prev_ring.radius, " + ", attacker.variation, " = ", prev_pos)
		var pos = lerp(prev_pos, next_pos, alpha)
		attacker.global_position = center.global_position + pos


func advance():
	# hide the advance hint after the first advance
	$GUI/AdvanceHint.visible = false
	
	# add points to score according to the level
	add_score(calculate_score_ring())
	
	# increment level
	level += 1
	
	# update attackers
	attackers_distance = max(-20, attackers_distance - 1)
	
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
		var static_elements = []
		
		# randomly populate the ring with bombs
		var num_bombs = level / 25 + round(rand_range(0, level / 50 + 2))
		var bombs = []
		while bombs.size() < num_bombs:
			var pos = randi() % 360
			if not enough_minimum_distance(pos, static_elements, minimum_distance):
				continue
			bombs += [pos]
			static_elements += [pos]
		instance.create_bombs(bombs)
		
		# randomly populate the ring with coins
		var num_coins = round(rand_range(0, 3))
		var coins = []
		while coins.size() < num_coins:
			var pos = randi() % 360
			if not enough_minimum_distance(pos, static_elements, minimum_distance):
				continue
			coins += [pos]
			static_elements += [pos]
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
		var rotation_speed = rand_range(30, 60 + level)
		var direction = 1 if randi() % 2 == 0 else -1
		var difficulty_modifier = settings.get_difficulty_modifier()
		instance.ring_rotation_ps = direction * rotation_speed * difficulty_modifier
	
	# return configurated instance
	return instance


func enough_minimum_distance(pos : float, elements : Array, minimum_distance : float) -> bool:
	for e in elements:
		if abs(e - pos) < minimum_distance:
			return false
	return true


func calculate_score_ring() -> int:
	return int(max(1, (1 + level / 10) * settings.get_difficulty_modifier()))


func calculate_score_coin() -> int:
	return int(max(1, (1 + level / 20) * settings.get_difficulty_modifier()))


func add_score(new_score : int):
	score += new_score
	score_label.text = str(score)
	if score > highscore and highscore > 0:
		$GUI/NewHighscoreLabel.show()


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
	$Misc/ExplosionSound.play()


func _on_Player_game_over():
	var game_over_label_text = "Score:"
	if score > highscore:
		save_system.save_score(score)
		game_over_label_text = "New high score:"
	$GUI/GameOver/ScoreLabel.text = game_over_label_text
	$GUI/GameOver/ScoreLabel/Value.text = str(score)
	$GUI/GameOver.visible = true
	$GUI/AdvanceHint.visible = false
	can_restart = true


func _on_Player_collected_coin():
	add_score(calculate_score_coin())
	$Misc/CoinSound.play()


func _on_ColorTimer_timeout():
	var next_color : Color = rand_color(10.0/255, 40.0/255)
	color_tween.interpolate_property(background, "modulate", background.modulate, next_color, 1.2)
	color_tween.start()


func rand_color(start_interval : float = 0, end_interval : float = 1) -> Color:
	return Color(
		rand_range(start_interval, end_interval),
		rand_range(start_interval, end_interval),
		rand_range(start_interval, end_interval))


func _on_PauseButton_button_down():
	if not paused:
		paused = true
		toggle_rings_rotation(false)
		$GUI/Paused.visible = true


func _on_Paused_back_to_main_menu():
	if paused:
		get_tree().change_scene_to(menu_scene)


func _on_PauseButton_mouse_entered():
	mouse_over_button = true


func _on_PauseButton_mouse_exited():
	mouse_over_button = false


func _on_StartTimer_timeout():
	ready_to_start = true


func _on_FullscreenModeButton_button_down():
	print("down")
	OS.window_fullscreen = not OS.window_fullscreen
