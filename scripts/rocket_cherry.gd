extends CharacterBody2D

@export var enemy_score := 100
@onready var anim = $anim as AnimatedSprite2D
@onready var path_2d = $"../path2D" as PathFollow2D

var jellyfish_life := 3

var isStunned = false
var ability := "super_speed"


func _on_hitbox_body_entered(body):
	anim.play("hurt")


func _on_animations_animation_finished():
	if anim.animation == "hurt":
		if jellyfish_life <= 0:
			isStunned = true
			anim.play("stunned")
			path_2d = false 
		else:
			jellyfish_life -= 1
			anim.play("walk")
	elif anim.animation == "death":
			queue_free()
			Globals.score += enemy_score
