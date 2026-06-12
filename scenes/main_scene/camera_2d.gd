extends Camera2D

var ssCount = 1

func _ready() -> void:
	var dir = DirAccess.open("user://")
	dir.make_dir("screenshots")

	dir = DirAccess.open("user://screenshots")
	for n in dir.get_files():
		ssCount += 1
	
func _input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F12:
			screenshot()
			get_viewport().set_input_as_handled()
	
func screenshot():
	await RenderingServer.frame_post_draw
	
	var viewport = get_viewport()
	var img = viewport.get_texture().get_image()
	img.save_png("user://screenshots/ss"+str(ssCount)+".png")
	ssCount += 1
