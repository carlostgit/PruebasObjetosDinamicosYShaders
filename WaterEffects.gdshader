// Converted/modified from ShaderToy: https://www.shadertoy.com/view/ldBXDD
// Attach this shader to a ColorRect

shader_type canvas_item;

//uniform float wave_count : hint_range(1.0, 200.0, 1.0) = 150.0;
//uniform float speed : hint_range(0.0, 300.0, 0.1) = 3.0;
//uniform float height : hint_range(0.0, 0.1, 0.001) = 0.003;


const float speed = 10.0;
const float width_of_wave = 10.00;
const float max_power_of_wave = 0.1;
const vec2 rect_size = vec2(64.0,64.0);

const vec2 position_in_local = vec2(0.0,0.0);

//const vec2 position_in_screen = vec2(500.0,250.0);


float get_power_of_wave(in vec2 position, in vec2 uv, in vec2 resolution, in float time, out vec2 direct_of_wave)
{
	vec2 cPos = uv;
		
	//Para que sea redondo, aunq la pantalla no sea cuadrada:
	cPos *= resolution;///length(resolution)*10.0;
	
	//Ahora tenemos tamaño constante para la pantalla
	
	cPos -= vec2(resolution.x/2.0,resolution.y/2.0);
	
	cPos -= vec2(position.x,-position.y);
	
	float cLength = length(cPos);
	
	float elapsed_time = 10.0*(time/10.0-floor(time/10.0));
	
	float dist_of_wave =  (elapsed_time*speed);
	
	float dist_to_wave = length(cPos)-dist_of_wave;
	
	float power_of_wave = 0.0;
	//if (dist_to_wave<0.1)
	if (abs(dist_to_wave) < width_of_wave)
	{
		power_of_wave = (1.0/width_of_wave)*(width_of_wave-abs(dist_to_wave))*sin(dist_to_wave*2.0*3.149/width_of_wave);
	}
	direct_of_wave = cPos/cLength;
	
	return power_of_wave;
}

void fragment() {
	
	vec2 uv = SCREEN_UV.xy;
	
	for (int i=0; i<1; i++)
	{
		
		vec2 position = position_in_local;
		position.x = position.x + float(i*10);
		//vec2 resolution = 1.0/SCREEN_PIXEL_SIZE;
		vec2 resolution = rect_size;
		
		vec2 direct_of_wave;
		float power_of_wave = get_power_of_wave(position, UV, resolution, TIME, direct_of_wave);
		if(power_of_wave!=0.0)
		{
			vec2 change_of_uv = max_power_of_wave*power_of_wave*direct_of_wave;
		
			uv += change_of_uv;
		}
	}
	COLOR = texture(SCREEN_TEXTURE,uv);
	COLOR = texture(TEXTURE,UV);
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

