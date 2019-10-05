extends KinematicBody2D

var motion = Vector2();

func _physics_process(delta):
	motion.y += 30;

	if Input.is_action_pressed("ui_left"):
		motion.x -= 6;
	if Input.is_action_pressed("ui_right"):
		motion.x += 6;
	if is_on_floor() && Input.is_action_pressed("ui_up"):
		motion.y -= 800;

	if is_on_floor():
		motion.x = lerp(motion.x, 0, 0.01);

	if is_on_floor() && motion.y >= 0:
		motion.y -= 500;

	motion = move_and_slide(motion, Vector2.UP);
