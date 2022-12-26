extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _applying_torque = 0.0
var _applying_force = Vector2(0.0,0.0)

#El barco avanzará más fácl en sentido longitudinal que lateral
var _affecting_extra_lateral_damp_force = Vector2(0.0,0.0)

var _left_key = false
var _right_key = false
var _up_key = false
var _down_key = false
var _home_key = false
var _end_key = false

var _last_row_point:Vector2 = Vector2()
var _last_row_point_time:float = 0.0

#para debugear
var _line_2D_local:Line2D = null
var _line_2D:Line2D = null
var _line_2D_damp_force:Line2D = null
var _line_2D_to_click:Line2D = null
var _line_2D_from_click_to_unclick:Line2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_line_2D_local = Line2D.new()
	_line_2D = Line2D.new()
	_line_2D_damp_force = Line2D.new()
	_line_2D_to_click = Line2D.new()
	_line_2D_from_click_to_unclick = Line2D.new()

	self.get_parent().call_deferred("add_child",_line_2D_local)
	self.get_parent().call_deferred("add_child",_line_2D)
	self.get_parent().call_deferred("add_child",_line_2D_damp_force)
	self.get_parent().call_deferred("add_child",_line_2D_to_click)
	self.get_parent().call_deferred("add_child",_line_2D_from_click_to_unclick)
	
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
	
	apply_lateral_damp_force()
		

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

	if event is InputEventMouseButton:
		_line_2D_to_click.clear_points()
		_line_2D_to_click.add_point(self.position)
#		_line_2D_to_click.add_point(self.get_global_mouse_position())
		_line_2D_to_click.add_point(self.get_parent().get_local_mouse_position())
		
		var lateral_dir_vector = Vector2(1.0,0.0)
		var local_lateral_dir_vector = self.transform.basis_xform(lateral_dir_vector)	
		
		var to_click_vector = self.get_parent().get_local_mouse_position() - self.position
		var horizontal_proyection_length = lateral_dir_vector.dot(to_click_vector)
		
		if(horizontal_proyection_length > 0.0):
			_line_2D_to_click.default_color = Color(1,0,0)
		else:
			_line_2D_to_click.default_color = Color(0,1,0)
		
#		if event.pressed:
#			_line_2D_from_click_to_unclick.clear_points()
#			_line_2D_from_click_to_unclick.add_point(self.get_parent().get_local_mouse_position())
#		else:
#			_line_2D_from_click_to_unclick.add_point(self.get_parent().get_local_mouse_position())
			
		if event.pressed:
			_last_row_point_time = float(Time.get_ticks_msec())*0.001
			_last_row_point = self.get_parent().get_local_mouse_position()
		else:
			if 0.0 !=_last_row_point_time:
				var new_row_point_time = float(Time.get_ticks_msec())*0.001
				var new_row_point = self.get_parent().get_local_mouse_position()
				_line_2D_from_click_to_unclick.clear_points()
				_line_2D_from_click_to_unclick.default_color = Color(1,0.5,0.5)
				_line_2D_from_click_to_unclick.add_point(_last_row_point)
				_line_2D_from_click_to_unclick.add_point(new_row_point)
				var row_movement_vect = new_row_point-_last_row_point
				var elapsed_time = new_row_point_time - _last_row_point_time
				var row_position = self.get_parent().get_local_mouse_position()
				apply_force_for_row_movement(row_movement_vect,row_position,elapsed_time)
				

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

func apply_lateral_damp_force():
	var lateral_dir_vector = Vector2(1.0,0.0)
	var local_lateral_dir_vector = self.transform.basis_xform(lateral_dir_vector)	
	
	#
	_line_2D_local.clear_points()
	_line_2D.clear_points()
	_line_2D_damp_force.clear_points()
	
	
	_line_2D_local.add_point(self.position + Vector2(0,0))
	_line_2D_local.add_point(self.position + local_lateral_dir_vector*100)
	
	
	_line_2D.add_point(self.position + Vector2(0,0))
	_line_2D.add_point(self.position + lateral_dir_vector*100)
	_line_2D.default_color = Color(1.0,0.0,0.0)
	
	_line_2D_damp_force.add_point(self.position + Vector2(0,0))
	_line_2D_damp_force.add_point(self.position + _affecting_extra_lateral_damp_force*100)
	_line_2D_damp_force.default_color = Color(0.0,1.0,0.0)
	#
	
	var lateral_velocity_amount = local_lateral_dir_vector.dot(self.linear_velocity)
	var lateral_velocity = lateral_velocity_amount*local_lateral_dir_vector
	
	var lateral_force_to_apply = Vector2(0.0, 0.0)
	
	var damp_factor = 1.0
	if(abs(lateral_velocity.length())>0.1):
		lateral_force_to_apply = -damp_factor*lateral_velocity
	
	reset_affecting_extra_lateral_damp_force()	
	_affecting_extra_lateral_damp_force = lateral_force_to_apply	
	self.add_central_force(lateral_force_to_apply)
	
func reset_affecting_extra_lateral_damp_force():
	self.add_central_force(-_affecting_extra_lateral_damp_force)
	_affecting_extra_lateral_damp_force = Vector2(0.0,0.0)
	
func apply_force_for_row_movement(row_movement_vect:Vector2 ,row_position:Vector2, elapsed_time:float):
	#var speed_of_row:float = row_movement_vect.length()/elapsed_time;
	var row_force_factor = 0.01
	var force_vec:Vector2 = -row_movement_vect*row_force_factor
	var vec_to_row:Vector2 = row_position - self.position
#	var torque:float = vec_to_row.cross(force_vec)
#	self.apply_torque_impulse(torque)
#	self.apply_central_impulse(force_vec)
	self.apply_impulse(vec_to_row,force_vec)
