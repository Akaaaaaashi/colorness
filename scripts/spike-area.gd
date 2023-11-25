extends Area2D
@onready var collision = $collision as CollisionShape2D
@onready var spike = $spike as Sprite2D


# Called when the node enters the scene tree for the first time.

func _on_body_entered(body):
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0, -250))
