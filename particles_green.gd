extends CPUParticles2D
@onready var slime = $".." as CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if slime.isStunned == false:
		print('pça')
