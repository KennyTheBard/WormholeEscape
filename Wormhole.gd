extends Node2D

export(int) var num_rings = 20
export(float) var advancing_period = 1.5

onready var ring_scene : PackedScene = preload("res://Ring.tscn")

onready var center : Position2D = $Center
onready var ring_container : Node2D = $RingContainer
onready var advancing_timer : Timer = $AdvancingTimer

var rings : Array = []
var advancing : bool = false
var level : int = 1
var image : Image = Image.new()
var bomb_texture : ImageTexture = ImageTexture.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	image.load("res://icon.png")
	bomb_texture.create_from_image(image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("advance") and not advancing:
		advancing = true
		advance()


func advance():
	# increment level
	level += 1
	
	# remove a ring if the desired number is reached
	if rings.size() >= num_rings:
		ring_container.remove_child(rings.pop_front())
	
	# add a new ring to the scene
	var instance = ring_scene.instance()
	instance.global_position = center.global_position
	instance.init(bomb_texture, [45, 120, 225])
	rings.push_back(instance)
	ring_container.add_child(instance)
	
	# start a radius increase transition
	for ring in rings:
		ring.increase_radius(ring.radius * 1.5, advancing_period)
	advancing_timer.start(advancing_period)


func generate_ring() -> Node2D:
	var instance = ring_scene.instance()
	var walls = range()
	instance.global_position = center.global_position
	instance.init(bomb_texture, [45, 120, 225])
	return instance


func _on_AdvancingTimer_timeout():
	advancing = false
