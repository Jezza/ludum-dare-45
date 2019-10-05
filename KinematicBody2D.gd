extends KinematicBody2D

const GRAVITY = 60
const TERMINAL_VELOCITY = 1000
const ACCELERATION = 50
const MAX_SPEED = 500
const JUMP_HEIGHT = -1000
const FRICTION = 0.2
const DRAG = 0.05

var motion = Vector2();

func _physics_process(delta):
	motion.y = min(motion.y + GRAVITY, TERMINAL_VELOCITY)
	var friction = true

	if Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		friction = not friction
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		friction = not friction

	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP_HEIGHT
		if friction:
			motion.x = lerp(motion.x, 0, FRICTION)
	else:
		if friction:
			motion.x = lerp(motion.x, 0, DRAG)
	
	motion = move_and_slide(motion, Vector2.UP, false, 4, 0.785398, false)
	
	#var pulse = Input.is_action_just_pressed("ui_accept");
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var collider = collision.collider;
		if collider.name.find("Wall") == -1:
			collider.apply_central_impulse(Vector2.UP);
			#print("Collided with: ", collider);
