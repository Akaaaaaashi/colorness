extends EnemyBase

@export var enemy_score := 100
@onready var anim2d = $anim as AnimatedSprite2D
@onready var path_2d = $"../path2D" as Path2D
@onready var animat = $"../anim" as AnimationPlayer
@onready var spawn_enemy = $"../spawn_enemy" as Marker2D
var active_gravity = false




var jellyfish_life := 3

var isStunned = false
var ability := "super_speed"


func _on_hitbox_body_entered(body):
	if isStunned:
		anim2d.play("death")
	else:
		anim2d.play("hurt")
		
		
func _physics_process(delta):
	pass
	
func _process(delta):
	if active_gravity:
		position.y += 15 * delta

func _on_animations_animation_finished():
	if anim2d.animation == "hurt":
		if jellyfish_life <= 0:
			isStunned = true
			anim2d.play("stunned")
			path_2d.queue_free()
			animat.queue_free()
			spawn_enemy.queue_free()
			active_gravity = true
		else:
			jellyfish_life -= 1
			anim2d.play("flying")
	elif anim2d.animation == "death":
			queue_free()
			Globals.score += enemy_score
	



