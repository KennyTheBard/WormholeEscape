extends TextureButton

onready var on_image : Image = Image.new()
onready var on_texture : ImageTexture = ImageTexture.new()

onready var off_image : Image = Image.new()
onready var off_texture : ImageTexture = ImageTexture.new()

var fullscreen : bool = OS.window_fullscreen


func _ready():
	on_image.load("res://assets/fullscreen_on.png")
	on_texture.create_from_image(on_image)
	
	off_image.load("res://assets/fullscreen_off.png")
	off_texture.create_from_image(off_image)
	
	texture_normal = off_texture if OS.window_fullscreen else on_texture


func _process(delta):
	if OS.window_fullscreen != fullscreen:
		texture_normal = off_texture if OS.window_fullscreen else on_texture
		fullscreen = OS.window_fullscreen

