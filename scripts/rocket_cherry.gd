extends CharacterBody2D

@export var enemy_score := 100
@onready var anim = $anim as AnimatedSprite2D
@onready var path_2d = $path2D as Path2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jellyfish_life := 3

var isStunned = false
var ability := "super_speed"


func _on_hitbox_body_entered(body):
	if isStunned:
		anim.play("death")
	else:
		anim.play("hurt")


func _on_animations_animation_finished():
	if anim.animation == "hurt":
		if jellyfish_life <= 0:
			isStunned = true
			anim.play("stunned")
		else:
			jellyfish_life -= 1
			anim.play("flying")
	elif anim.animation == "death":
			queue_free()
			Globals.score += enemy_score
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


