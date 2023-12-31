extends CharacterBody2D


var SPEED = 150.0
var JUMP_FORCE = -250.0
var mode = ""
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_jumping := false
var is_hurterd := false
var knockback_vector := Vector2.ZERO
var direction
@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

signal player_has_died()

func _physics_process(delta):
	#print(position)
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
	elif is_on_floor():
		is_jumping = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.play("run")
		animation.scale.x = direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()
	
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)


func _on_hurtbox_body_entered(body):
#	if body.is_in_group("enemies"):
#		queue_free()

		if $ray_right.is_colliding():
			take_damage(Vector2(-200, -200))
		elif $ray_left.is_colliding():
			take_damage(Vector2(200, -200))
		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("player_has_died")
	
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1,1,1,1), duration)

	is_hurterd = true
	await get_tree().create_timer(.3).timeout
	is_hurterd = false
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
	if is_hurterd:
		state = "hurt"
	if animation.name != state:
		print(state+mode)
		animation.play(state+mode)



func _on_head_collider_body_entered(body):
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 1:
			body.break_sprite()
		else:
			body.animation_player.play("hit")
			body.create_coin()
			
func _input(event):

	if event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE
			is_jumping = true
		elif is_on_floor():  
			is_jumping = false
	else:
		#Botão de absorção
		if Input.is_action_just_pressed("absorb"):
			if absorbable == true:
				#Comando para subir 100 a pontuação quando vc absorve o slime
				#var particles_scene = preload("res://prefabs/particles_green.tscn")
				#var particles_green = particles_scene.instance()
				#particles_green.global_transform = global_transform
				#get_parent().add_child(particles_green)	
				enemy_in_range.particles_green.show()	
				enemy_in_range.texture.hide()
				enemy_in_range.collision.queue_free()
				enemy_in_range.hitbox.queue_free()
				enemy_in_range.absorbed = true	
				#enemy_in_range.particles_green.position = enemy_in_range.particles_green.position.lerp(position, 0.01666666666667 * 2.0)
				Globals.score += 100
				#enemy_in_range.queue_free()
				#Habilidade de super pulo
				if enemy_in_range.ability == "super_jump":
					JUMP_FORCE = -400.0
					mode = "_green"
				if enemy_in_range.ability == "super_speed":
					SPEED = 150.0


#Sistema de absorção
var absorbable := false
var enemy_in_range = null

func _on_range_absorb_area_entered(body):
	if body.owner.name == "slime":
		if body.owner.isStunned == true:
			absorbable = true
			enemy_in_range = body.owner
		
func _on_range_absorb_area_exited(area):
	absorbable = false
	enemy_in_range = null
