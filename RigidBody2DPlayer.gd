extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _applying_torque = 0.0
var _applying_force = Vector2(0.0,0.0)

var _left_key = false
var _right_key = false
var _up_key = false
var _down_key = false
var _home_key = false
var _end_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var sum_of_force = Vector2(0,0)
	var sum_of_torque = 0.0
	if _left_key:
		sum_of_force += (Vector2(-100,0))
		print("LEFT was pressed")
	if _right_key:
		sum_of_force += (Vector2(100,0))
		print("RIGHT was pressed")
	if _up_key:
		sum_of_force += (Vector2(0,-100))
		print("UP was pressed")
	if _down_key:
		sum_of_force += (Vector2(0,100))
		print("DOWN was pressed")
	if _home_key:
		sum_of_torque += -1000.0
		print("HOME was pressed")
	if _end_key:
		sum_of_torque += 1000.0
		print("END was pressed")

	
	self.apply_force(sum_of_force)
	self.apply_torque(sum_of_torque)
		

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
	if event is InputEventKey and event.is_action_pressed("ui_home"):
		_home_key = true;
	if event is InputEventKey and event.is_action_released("ui_home"):
		_home_key = false;
	if event is InputEventKey and event.is_action_pressed("ui_end"):
		_end_key = true;
	if event is InputEventKey and event.is_action_released("ui_end"):
		_end_key = false;

func apply_force(var vector_force):
	reset_force()
	#self.transform.basis.xform
	#Eso de basis_xform hace que solo se coja la parte de la rotación y escalado de la matriz transform
	#Así orientamos nuestro vector de fuerzas a valores locales de nuestro nodo RigidBody
	var vector_local_force = self.transform.basis_xform(vector_force)	
	_applying_force = vector_local_force
	self.add_central_force(vector_local_force)
	
func reset_force():
	self.add_central_force(-_applying_force)
	_applying_force = Vector2(0.0,0.0)
	
func apply_torque(var torque):
	reset_torque()
	_applying_torque = torque
	self.add_torque(torque)

func reset_torque():
	self.add_torque(-_applying_torque)
	_applying_torque = 0.0

