shader_type canvas_item;

uniform float r_offset : hint_range(-5, 5) = 0.0;
uniform float g_offset : hint_range(-5, 5) = 0.5;
uniform float b_offset : hint_range(-5, 5) = -0.5;

void fragment()
{
	vec3 color = COLOR.rgb;
	float r = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x*r_offset), 0.0).r;
	float g = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x*g_offset), 0.0).g;
	float b = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE.x*b_offset), 0.0).b;
	COLOR.rgb = color;
}