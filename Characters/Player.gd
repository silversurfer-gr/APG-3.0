extends KinematicBody2D

enum { NORMAL, JUMP, FALL, LAND, DIE }
const GRAVITY = 80
const JUMP_VELOCITY = -100
const AIR_JUMP_MULTI := 0.75

onready var velocity:Vector2 = Vector2.ZERO

export var speed := 65
export var air_control := true
export var max_air_jumps := 1

var state := NORMAL
var air_jumps := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
		
	match state:
		NORMAL:
			horizontal()
			if Input.is_action_just_pressed("ui_up"):
				air_jumps = max_air_jumps
				state = JUMP
				jump()
		JUMP:
			jump()
		FALL:
			if is_on_floor():
				state = LAND
		LAND:
			state = NORMAL
		DIE:
			pass
			
	


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	
func horizontal():
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed
		$Sprite.flip_h = false
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		$Sprite.flip_h = true
	elif is_on_floor() or air_control:
		velocity.x = 0
		
		
	# Animation
	if is_on_floor():
		if velocity.x == 0:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("jump")
		
func jump():
	if air_control:
		horizontal()
	
	if Input.is_action_just_pressed("ui_up") and air_jumps >= 0:
		$AnimationPlayer.play("jump")
		if air_jumps == max_air_jumps:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY * AIR_JUMP_MULTI
		
		air_jumps -= 1
		
	if is_on_floor() and velocity.y >= 0:
		state = LAND
