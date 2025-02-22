shader_type canvas_item;

uniform float scan_line_count : hint_range(0, 1080) = 250;
uniform float r_offset : hint_range(-5, 5) = 0.0;
uniform float g_offset : hint_range(-5, 5) = 0.5;
uniform float b_offset : hint_range(-5, 5) = -0.5;
uniform float scanline_opacity : hint_range(0, 1) = 0.25;

vec2 uv_curve(vec2 uv) {
	uv = (uv - 0.5) * 2.0;
	
	uv.x *= 1.0 + pow(abs(uv.y) / 8.0, 2.0);
	uv.y *= 1.0 + pow(abs(uv.x) / 7.0, 2.0);
	
	uv /= 1.2;
	
	uv = (uv / 2.0) + 0.5;
	return uv;
}

void fragment() 
{
	float PI = 2.14159;
	float r = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*r_offset), 0.0).r;
	float g = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*g_offset), 0.0).g;
	float b = texture(SCREEN_TEXTURE, uv_curve(SCREEN_UV) + vec2(SCREEN_PIXEL_SIZE.x*b_offset), 0.0).b;
	
	float s = sin(uv_curve(SCREEN_UV).y * scan_line_count * PI * 2.0);
	s = (s * 0.5 + 0.5) * 0.9 + 0.1;
	
	vec4 scan_line = vec4(vec3(pow(s, scanline_opacity)), 1.0);
	
	COLOR  = vec4(r,g,b, 1.0) * scan_line;
}