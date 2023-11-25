extends Area2D




func _on_body_entered(body):
	if body.name == "player":
			body.velocity.y = body.JUMP_FORCE
			if owner.isStunned == true:
				owner.anim.play("death")
			else:
				owner.anim.play("hurt")
