extends Area2D


func _on_body_entered(body):
	if body.name == "player":
			body.velocity.y = body.JUMP_FORCE
			if owner.rocket_cherry.isStunned == true:
				owner.rocket_cherry.anim.play("death")
			else:
				owner.rocket_cherry.anim.play("hurt")
