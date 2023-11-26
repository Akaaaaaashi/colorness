extends CharacterBody2D

const SPEED = 1200.0
const JUMP_VELOCITY = -400.0
var isStunned = false
var slime_life := 3
var ability := "super_jump"
var absorbed := false
@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var collision := $collision as CollisionShape2D
@onready var hitbox := $hitbox as Area2D
@onready var anim := $anim as AnimationPlayer
@onready var particles_green := $particles_green as CPUParticles2D
var direction := -1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var enemy_score := 100

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		#wall_detector.scale.x *= -1
		
	if direction == -1:
		texture.flip_h = true
	else:
		texture.flip_h = false
		
		
		
	velocity.x = direction * SPEED * delta
	move_and_slide()


func _on_anim_animation_finished(anim_name):
	if anim_name == "hurt":
		if slime_life <= 0:
			isStunned = true
			anim.play("stunned")
			direction = 0
		else:
			slime_life -= 1
			anim.play("walk")
	elif anim_name == "death":
		#texture.hide()
		#hitbox.queue_free()
		#collision.queue_free()
		#particles_green.show()
		Globals.score += enemy_score
		queue_free()
