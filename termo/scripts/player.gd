extends CharacterBody2D
 
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D  
@onready var jump_particles: GPUParticles2D = $JumpParticles
@onready var timer_dash_end: Timer = $Timers/TimerDashEnd
@onready var timer_dash: Timer = $Timers/TimerDash
@onready var timer_muerte: Timer = $Timers/TimerMuerte

const SPEED = 130.0 	
const JUMP_VELOCITY = -350.0
const GRAVITY = 1000
const FALL_GRAVITY = 1200
const dash = 500

var  tween: Tween
var dash_velocity = 0.0
var candash = true
var isdash = false



func _physics_process(delta: float) -> void:
	dashFunc()  
	# Handle jump.
	if Input.is_action_just_released("jump") and velocity.y  < 0:
		velocity.y =JUMP_VELOCITY /4
		jump_particles.emitting=false
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jump_particles.emitting=true 
	#movement input -1 0 1
	var direction := Input.get_axis("move_left", "move_right")
	#flip
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
		
		
	#animation
	if is_on_floor() or is_on_wall():
		if direction == 0:
			animated_sprite.play("idle")   
		elif direction != 0:
			animated_sprite.play("run")  
	elif not is_on_wall() or not is_on_floor():
		animated_sprite.play("jump")
		
		
	
	#movement
	if direction:
		velocity.x = direction * (SPEED + dash_velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if is_on_wall():
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			if Input.is_action_just_pressed("move_right"):
				velocity.x = direction * SPEED * 3.5   
			if Input.is_action_just_pressed("move_left"):
				velocity.x = direction * SPEED * 3.5   
		
 
	velocity.y += _get_gravity(velocity) * delta
			  
func muerte():  	 
	if isdash == false:
		set_physics_process(false)
		animated_sprite.play("death") 
		timer_muerte.start()
		print("asdasd")
	
	




func dashFunc():
	if Input.is_action_just_pressed("shift") and candash==true:
		dash_velocity = dash
		candash = false 
		isdash = true
		timer_dash.start()
		timer_dash_end.start()
		if tween:  
			tween.stop() 
		tween = create_tween()
		tween.tween_property(self, "dash_velocity",0,0.2).set_ease(Tween.EASE_OUT)
		


 

func _get_gravity(velocity: Vector2):
	if  velocity.y < 0:
		return GRAVITY
	return FALL_GRAVITY


func _on_timer_timeout() -> void: 
	if is_on_floor() == true:
		candash = true


func _on_timer_muerte_timeout() -> void:
	get_tree().reload_current_scene()


func _on_timer_dash_end_timeout() -> void:
	isdash = false 
