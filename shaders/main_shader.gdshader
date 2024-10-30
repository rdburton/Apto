shader_type spatial;

uniform float roughness : hint_range(0.0, 1.0, 0.1);
uniform float metallic : hint_range(0.0, 1.0, 0.1);

uniform vec4 color_start : source_color = vec4(1.0, 0.6, 0.6, 1.0);
uniform vec4 color_end : source_color = vec4(1.0, 0.85, 0.65, 1.0);
uniform vec3 gradient_dir = vec3(0.0);

uniform float min_value = -1.0;
uniform float max_value = 1.0;

uniform float fade_start = 10.0;
uniform float fade_end = 50.0;
uniform vec4 fade_color : source_color = vec4(0.0);

void fragment()
{
	float gradient_factor = dot(VERTEX, gradient_dir);
	gradient_factor = (gradient_factor - min_value) / (max_value - min_value);
	gradient_factor = clamp(gradient_factor, 0.0, 1.0);
	
	vec4 gradient_color = mix(color_start, color_end, gradient_factor);
	
	float distance_to_camera = length(VIEW);
	float fade_factor = (distance_to_camera - fade_start) / (fade_end - fade_start);
	fade_factor = clamp(fade_factor, 0.0, 1.0);
	
	vec4 final_color = mix(gradient_color, fade_color, fade_factor);
	
	ALBEDO = final_color.rgb;
	ROUGHNESS = roughness;
	METALLIC = metallic;
}
