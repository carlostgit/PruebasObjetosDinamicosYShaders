extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var wave_index = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	var rect_size = self.get_rect().size
#	var rect_size = self.get_rect().size*self.scale
	material.set_shader_param("u_rect_size", rect_size)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ColorRectWithShader_item_rect_changed():
	
	var rect_size = self.get_rect().size
	#var rect_size = self.get_rect().size*self.scale
	material.set_shader_param("u_rect_size", rect_size)
	
	pass # Replace with function body.


func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position)
		print("Local Mouse Motion at: ", self.get_local_mouse_position())
		#print("Local using to_local: ", self.to_local(self.get_global_mouse_position()))
#		print("Position in parent: ", self.position)
		#print("Global transf with canv: ", self.get_global_transform_with_canvas())
		##rint("Global transf: ", self.get_global_transform())
		var screen_coord_0 = get_viewport_transform() * (get_global_transform() * Vector2(0,0))
		print("Local 0 to global: ", screen_coord_0)
		
		#El truco para q pasar a local funcione es el affine (q es necesario cuando hay escalado)
		#y cuidado también con el orden de las transformaciones
		var local_from_screen = get_global_transform().affine_inverse()*((get_viewport_transform().affine_inverse())*(event.position))
		print("Local from screen mouse position: ", local_from_screen)
		
		if (event.pressed):
			
			var time_event  = (float(OS.get_ticks_msec())/1000.0)
			#var time_event = Time.get_unix_time_from_system()
			if (0==wave_index):
				material.set_shader_param("u_time_event", time_event)
				material.set_shader_param("u_local_position", local_from_screen)
				wave_index = 1
			elif(1==wave_index):
				material.set_shader_param("u_time_event_2", time_event)
				material.set_shader_param("u_local_position_2", local_from_screen)
				wave_index =2
			else:
				material.set_shader_param("u_time_event_3", time_event)
				material.set_shader_param("u_local_position_3", local_from_screen)
				wave_index =0
				
		
		#var global_coord_0 = (get_global_transform() * Vector2(0,0))
		#print("Local 0 with get_global_transform(): ", global_coord_0)
		
		#var viewport_coord_0 = (get_viewport_transform() * Vector2(0,0))
		#print("Local 0 with get_viewport_transform(): ", viewport_coord_0)
		
		
		#var screen_coord_0 = get_viewport_transform() * (get_global_transform() * Vector2(0,0))
		#var screen_coord_30_30 = get_viewport_transform() * (get_global_transform() * Vector2(30,30))
		#print("Screen coord 0: ", screen_coord_0)
		#print("Screen coord 30 30: ", screen_coord_30_30)
		#var local_coord_0 = transform.xform_inv(Vector2(0,0))
		#var local_coord_300_300 = (get_viewport_transform().inverse()) * ((get_global_transform().inverse()) * Vector2(300,300))
		#print("Local coord 0: ", local_coord_300_300)
		#var local_coord_300_300_2 = (get_global_transform().inverse())*get_canvas_transform().inverse()*(event.position)
		#print("Local coord 0_2: ", local_coord_300_300_2)
		
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)
	# Print the size of the viewport.
	#print("Viewport Resolution is: ", get_viewport_rect().size)	
	
