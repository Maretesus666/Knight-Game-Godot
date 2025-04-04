extends Area2D
@onready var timer = $Timer 

func _on_body_entered(body) -> void: 
	if body.is_in_group("player"):  
		body.muerte() 
	  
