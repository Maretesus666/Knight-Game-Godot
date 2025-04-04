extends Node2D

const speed = 40 
var direction = 1
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $killzone/CollisionShape2D

func _isdash():
	collision_shape_2d.disabled = true

func _notdash():
	collision_shape_2d.disabled = false

func _process(_delta: float) -> void:
	if ray_cast_right.is_colliding():
		direction=-1
		animated_sprite.flip_h = true
	
	if ray_cast_left.is_colliding():
		direction=1
		animated_sprite.flip_h = false
	position.x+= direction*speed*_delta
