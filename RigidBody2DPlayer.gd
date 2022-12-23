extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _left_key = false
var _right_key = false
var _up_key = false
var _down_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if _left_key:
		self.add_force(Vector2(-100.0, 0), Vector2(0.0,-5.0))
		print("LEFT was pressed")
	elif _right_key:
		self.add_force(Vector2(+100.0, 0), Vector2(0.0,-5.0))
		print("RIGHT was pressed")
	elif _up_key:
		self.add_central_force(Vector2(0.0,-5.0))
		print("UP was pressed")
	elif _down_key:
		self.add_central_force(Vector2(0.0,5.0))
		print("DOWN was pressed")

#	pass

func _input(event):
#	if event is InputEventKey and event.pressed:
#		if event.scancode == KEY_LEFT:
#			print("LEFT was pressed")
#	if event.scancode == KEY_RIGHT:
#			print("RIGHT was pressed")
			
	if event is InputEventKey and event.is_action_pressed("ui_left"):
		_left_key = true;
	if event is InputEventKey and event.is_action_released("ui_left"):
		_left_key = false;
	if event is InputEventKey and event.is_action_pressed("ui_right"):
		_right_key = true;
	if event is InputEventKey and event.is_action_released("ui_right"):
		_right_key = false;
	if event is InputEventKey and event.is_action_pressed("ui_up"):
		_up_key = true;
	if event is InputEventKey and event.is_action_released("ui_up"):
		_up_key = false;
	if event is InputEventKey and event.is_action_pressed("ui_down"):
		_down_key = true;
	if event is InputEventKey and event.is_action_released("ui_down"):
		_down_key = false;

