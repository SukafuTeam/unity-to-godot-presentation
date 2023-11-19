extends VideoStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	finished.connect(on_finished)

func on_finished():
	play()