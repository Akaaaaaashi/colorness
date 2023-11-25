extends CharacterBody2D

@export var enemy_score := 100
@onready var anim = $anim as AnimatedSprite2D

var isStunned = false
var ability := "super_speed"


func _on_hitbox_body_entered(body):
	anim.play("hurt")


func _on_animations_animation_finished():
	
	
	
	if anim.animation == "hurt":
		queue_free()
		Globals.score += enemy_score
