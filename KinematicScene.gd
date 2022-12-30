extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#para debugear
#var _line_2D:Line2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
#	_line_2D = Line2D.new()
#	self.call_deferred("add_child",_line_2D)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _input(event):
#
#		# Mouse in viewport coordinates.
#	if event is InputEventMouseButton:
#
#		if false==event.pressed:
#			print("Mouse Unclick at: ", event.position)
#
#		if event.pressed:
#			print("Mouse Click at: ", event.position)
#
#			print("Local Mouse Motion at: ", self.get_local_mouse_position())
#			#print("Local using to_local: ", self.to_local(self.get_global_mouse_position()))
#	#		print("Position in parent: ", self.position)
#			#print("Global transf with canv: ", self.get_global_transform_with_canvas())
#			##rint("Global transf: ", self.get_global_transform())
#			var screen_coord_0 = get_viewport_transform() * (get_global_transform() * Vector2(0,0))
#			print("Local 0 to screen: ", screen_coord_0)
#
#			#No existe transform para un ColorRect	
#	#		var local_from_screen_with_transform = self.transform.basis_xform((event.position))
#	#		print("Local from screen mouse position transform: ", local_from_screen_with_transform)
#
#
#			#El truco para q pasar a local funcione es el affine (q es necesario cuando hay escalado)
#			#y cuidado también con el orden de las transformaciones
#			var local_from_screen = get_global_transform().affine_inverse()*((get_viewport_transform().affine_inverse())*(event.position))
#			print("Local from screen mouse position: ", local_from_screen)
#
#
#			print("$RigidBody2DPlayer.position: ", $RigidBody2DPlayer.position)
#
##			_line_2D.clear_points()
##
##			_line_2D.add_point($RigidBody2DPlayer.position + Vector2(0,0))
##			_line_2D.add_point(self.get_local_mouse_position())

	
	
