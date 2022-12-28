// Converted/modified from ShaderToy: https://www.shadertoy.com/view/ldBXDD
// Attach this shader to a ColorRect

shader_type canvas_item;

//uniform float wave_count : hint_range(1.0, 200.0, 1.0) = 150.0;
//uniform float speed : hint_range(0.0, 300.0, 0.1) = 3.0;
//uniform float height : hint_range(0.0, 0.1, 0.001) = 0.003;


const float speed = 50.0;
const float u_width_of_wave = 50.00;
const float max_power_of_wave = 0.005;

uniform vec2 u_rect_size = vec2(64.0,64.0);

uniform vec2 u_local_position = vec2(0.0,0.0);
uniform float u_time_event = 0.0;

uniform vec2 u_local_position_2 = vec2(0.0,0.0);
uniform float u_time_event_2 = 0.0;

uniform vec2 u_local_position_3 = vec2(0.0,0.0);
uniform float u_time_event_3 = 0.0;

uniform vec2 u_local_position_4 = vec2(0.0,0.0);
uniform float u_time_event_4 = 0.0;

uniform vec2 u_local_position_5 = vec2(0.0,0.0);
uniform float u_time_event_5 = 0.0;

uniform vec2 u_local_position_6 = vec2(0.0,0.0);
uniform float u_time_event_6 = 0.0;

uniform vec2 u_local_position_7 = vec2(0.0,0.0);
uniform float u_time_event_7 = 0.0;

//const vec2 position_in_screen = vec2(500.0,250.0);


float get_slope_of_wave(in float dist_to_center)
{
	//cosin wave
	float sin_wave = -0.5*(1.0+sin((dist_to_center*3.149/u_width_of_wave)));
	
	return sin_wave;
}

float get_height_from_dist_to_center_of_wave(in float dist_to_center)
{
	
//	//sine wave
//	float sin_wave = (1.0/u_width_of_wave)*(u_width_of_wave-abs(dist_to_center))*sin(dist_to_center*2.0*3.149/u_width_of_wave);
//	return sin_wave;
	
//	//pulse wave
//	float dist_normalized = dist_to_center/u_width_of_wave;
//	float pulse_wave = 1.0-dist_normalized*dist_normalized*(3.0-2.0*dist_normalized);
//	return pulse_wave;
	
	//cosin wave
	float cos_wave = -0.5*(1.0+cos((dist_to_center*3.149/u_width_of_wave)));
	return cos_wave;



}

vec2 calc_change_of_uv_ambiental_waves(in float time, in vec2 uv)
{
	vec2 cPos = uv;
	
	cPos *= u_rect_size;///length(resolution)*10.0;
	
//	cPos -= vec2(position.x,position.y);
	
	float cLength = length(cPos);
	
	//float elapsed_time = 10.0*(time/10.0-floor(time/10.0));
	float elapsed_time = time;
	
	float initial_advance = 50.0; //Para que empiece ya con un tamaño
	
	float dist_of_wave =  (elapsed_time*speed) + initial_advance;
	
	float dist_to_wave = length(cPos)-dist_of_wave;
	
	vec2 direct_of_wave = cPos/cLength;
	
	float power_of_wave = 0.0;
	float slope_of_wave = 0.0;
	vec3 direct_of_wave_with_slope = vec3(0.0,0.0,1.0);
	//if (dist_to_wave<0.1)
//	if (abs(dist_to_wave) < u_width_of_wave)
	{
		power_of_wave = 0.1*get_height_from_dist_to_center_of_wave(dist_to_wave);
		slope_of_wave = get_slope_of_wave(dist_to_wave);
		if (slope_of_wave>0.0)
		{
			direct_of_wave_with_slope = vec3((direct_of_wave)*slope_of_wave,1.0);
		}
		else
		{
			direct_of_wave_with_slope = vec3((direct_of_wave)*slope_of_wave,1.0);
		}
		
	}
	
	vec2 change_of_uv = max_power_of_wave*power_of_wave*direct_of_wave;
	
	return change_of_uv;
}


float get_power_of_wave(in vec2 position, in vec2 uv, in float time, out vec2 direct_of_wave, out vec3 direct_of_wave_with_slope)
{
	vec2 cPos = uv;
		
	//Para que sea redondo, aunq la pantalla no sea cuadrada:
	cPos *= u_rect_size;///length(resolution)*10.0;
	
	//Ahora tenemos tamaño constante para la pantalla
	
	//cPos -= vec2(resolution.x/2.0,resolution.y/2.0);
	cPos -= vec2(0.0,0.0);
	
	cPos -= vec2(position.x,position.y);
	
	float cLength = length(cPos);
	
	//float elapsed_time = 10.0*(time/10.0-floor(time/10.0));
	float elapsed_time = time;
	
	float initial_advance = 50.0; //Para que empiece ya con un tamaño
	
	float dist_of_wave =  (elapsed_time*speed) + initial_advance;
	
	float dist_to_wave = length(cPos)-dist_of_wave;
	
	direct_of_wave = cPos/cLength;
	
	float power_of_wave = 0.0;
	float slope_of_wave = 0.0;
	direct_of_wave_with_slope = vec3(0.0,0.0,1.0);
	//if (dist_to_wave<0.1)
	if (abs(dist_to_wave) < u_width_of_wave)
	{
		power_of_wave = get_height_from_dist_to_center_of_wave(dist_to_wave);
		slope_of_wave = get_slope_of_wave(dist_to_wave);
		if (slope_of_wave>0.0)
		{
			direct_of_wave_with_slope = vec3((direct_of_wave)*slope_of_wave,1.0);
		}
		else
		{
			direct_of_wave_with_slope = vec3((direct_of_wave)*slope_of_wave,1.0);
		}
		
	}
	
	return power_of_wave;
}

vec2 calc_change_of_uv(in float time_event, in vec2 local_position, in vec2 local_uv, out vec3  direct_of_wave_with_slope)
{
	vec2 change_of_uv = vec2(0.0,0.0);
	
	vec2 position = local_position;
		
	
	float time_wave = TIME-time_event;
	
	vec2 direct_of_wave;
	float power_of_wave = get_power_of_wave(position, local_uv, time_wave, direct_of_wave, direct_of_wave_with_slope);

	//direct_of_wave = vec2(-0.1,0.0);
	
	if(power_of_wave!=0.0)
	{
			change_of_uv = max_power_of_wave*power_of_wave*direct_of_wave;
	}
//	vec2 test_dir = vec2(1.0,1.0);
//	vec2 test_dir_norm = -test_dir/length(test_dir);
//	change_of_uv = max_power_of_wave*test_dir_norm;
	
	return change_of_uv;
	
}

void fragment() {
	
	vec2 resolution = u_rect_size;
	vec2 uv = SCREEN_UV.xy;
	
	
//	//for (int i=0; i<1; i++)
//	{
//
//		vec2 position = u_local_position;
//		//position.x = position.x + float(i*10);
//		//vec2 resolution = 1.0/SCREEN_PIXEL_SIZE;
//
//
//		float time_wave = TIME-u_time_event;
//
//		vec2 direct_of_wave;
//		float power_of_wave = get_power_of_wave(position, UV, time_wave, direct_of_wave);
//		if(power_of_wave!=0.0)
//		{
//			vec2 change_of_uv = max_power_of_wave*power_of_wave*direct_of_wave;
//
//			uv += change_of_uv;
//		}
//	}

	vec3 sun_direction = vec3(1.0,0.0,-1.0);
	vec3 sun_direction_norm = sun_direction/length(sun_direction);

	float light_factor_of_wave = 0.0;
	float light_factor_of_wave_2 = 0.0;
	float light_factor_of_wave_3 = 0.0;
	float light_factor_of_wave_4 = 0.0;
	float light_factor_of_wave_5 = 0.0;
	float light_factor_of_wave_6 = 0.0;
	float light_factor_of_wave_7 = 0.0;
	

	vec3  direct_of_wave_with_slope;
	vec3  direct_of_wave_with_slope_2;
	vec3  direct_of_wave_with_slope_3;
	vec3  direct_of_wave_with_slope_4;
	vec3  direct_of_wave_with_slope_5;
	vec3  direct_of_wave_with_slope_6;
	vec3  direct_of_wave_with_slope_7;



	float max_sum_power_of_wave = max_power_of_wave*5.0;
	
	float color_change_intensity_param = 0.1;
	vec4 color_change_combi = vec4(-1.0,-1.0,-1.0,0.0);
	float flat_sea_factor = dot(sun_direction_norm,vec3(0.0, 0.0, 1.0)); //Para q lo q no es ola, no cambie
	
	vec2 change_uv = calc_change_of_uv(u_time_event, u_local_position, UV, direct_of_wave_with_slope);
	light_factor_of_wave = dot(sun_direction_norm,direct_of_wave_with_slope)-flat_sea_factor;
//	float change_uv_length = length(change_uv);
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_2, u_local_position_2, UV, direct_of_wave_with_slope_2);		
		light_factor_of_wave_2 = dot(sun_direction_norm,direct_of_wave_with_slope_2)-flat_sea_factor;
	}
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_3, u_local_position_3, UV, direct_of_wave_with_slope_3 );
		light_factor_of_wave_3 = dot(sun_direction_norm,direct_of_wave_with_slope_3)-flat_sea_factor;
	}
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_4, u_local_position_4, UV, direct_of_wave_with_slope_4 );
		light_factor_of_wave_4 = dot(sun_direction_norm,direct_of_wave_with_slope_4)-flat_sea_factor;
	}
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_5, u_local_position_5, UV, direct_of_wave_with_slope_5 );
		light_factor_of_wave_5 = dot(sun_direction_norm,direct_of_wave_with_slope_5)-flat_sea_factor;
	}
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_6, u_local_position_6, UV, direct_of_wave_with_slope_6 );
		light_factor_of_wave_6 = dot(sun_direction_norm,direct_of_wave_with_slope_6)-flat_sea_factor;
	}
	if (length(change_uv)<max_sum_power_of_wave)
	{
		change_uv += calc_change_of_uv(u_time_event_7, u_local_position_7, UV, direct_of_wave_with_slope_7 );
		light_factor_of_wave_7 = dot(sun_direction_norm,direct_of_wave_with_slope_7)-flat_sea_factor;
	}
	
	
	
	uv += change_uv;
	
	uv += calc_change_of_uv_ambiental_waves(TIME,UV);
//	uv += calc_change_of_uv(u_time_event_2, u_local_position_2, UV, direct_of_wave_with_slope_2);
//	uv += calc_change_of_uv(u_time_event_3, u_local_position_3, UV, direct_of_wave_with_slope_3 );
//	uv += calc_change_of_uv(u_time_event_4, u_local_position_4, UV, direct_of_wave_with_slope_4 );
//	uv += calc_change_of_uv(u_time_event_5, u_local_position_5, UV, direct_of_wave_with_slope_5 );
//	uv += calc_change_of_uv(u_time_event_6, u_local_position_6, UV, direct_of_wave_with_slope_6 );
//	uv += calc_change_of_uv(u_time_event_7, u_local_position_7, UV, direct_of_wave_with_slope_7 );
	//vec4 color_change =  vec4(-0.05,-0.05,-0.05, 1.0)*change_uv_length/max_power_of_wave;
	

	
	
//	float medium_factor_of_wave = (light_factor_of_wave + light_factor_of_wave_2 + light_factor_of_wave_3)/3.0;
	
	vec4 color_change =  color_change_combi*color_change_intensity_param*light_factor_of_wave;
	vec4 color_change_2 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_2;
	vec4 color_change_3 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_3;
	vec4 color_change_4 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_4;
	vec4 color_change_5 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_5;
	vec4 color_change_6 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_6;
	vec4 color_change_7 =  color_change_combi*color_change_intensity_param*light_factor_of_wave_7;
	
	vec4 sum_of_color_change = color_change;
	sum_of_color_change+=color_change_2;
	sum_of_color_change+=color_change_3;
	sum_of_color_change+=color_change_4;
	sum_of_color_change+=color_change_5;
	sum_of_color_change+=color_change_6;
	sum_of_color_change+=color_change_7;
	
	
	
//	for (int i=0;i<100;i++)
//	{
//		float time_increment = 0.4*float(i);
//		vec2 position_increment = vec2(4.0*float(i),0.0);
//		uv += calc_change_of_uv(u_time_event+time_increment, u_local_position+position_increment, UV );
//	}
	
//	COLOR = texture(SCREEN_TEXTURE,uv);
	
	vec4 text_color = texture(SCREEN_TEXTURE,uv);
	COLOR = text_color+sum_of_color_change;
	
	//COLOR = texture(TEXTURE,UV);
	//vec2 texture_resolution = 1.0/TEXTURE_PIXEL_SIZE;
	//vec2 texture_res_cent = texture_resolution/1.2;
	//COLOR.b = step(UV.y,texture_res_cent.x);
	//vec2 texture_resolution = vec2(256.0,256.0);
	//vec2 screen_resolution = 1.0/SCREEN_PIXEL_SIZE;
	//float sprite_uv_h = texture_resolution.y / screen_resolution.y;
	
	//vec2 text_pos_0 = vec2(0.0,0.0);
	
	//vec2 flipped_screen_uv = vec2(SCREEN_UV.x, 1.0- SCREEN_UV.y );
		
	//COLOR = texture(SCREEN_TEXTURE,flipped_screen_uv);
	
	//if(abs(flipped_screen_uv_pos_0.x - SCREEN_UV.x) < 0.0000001)
	//{
	//	COLOR.b = 1.0;
	//}	
		
}

