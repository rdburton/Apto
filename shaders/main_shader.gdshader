shader_type spatial;
render_mode blend_mix, depth_prepass_alpha;

uniform float roughness : hint_range(0.0, 1.0, 0.1);
uniform float metallic : hint_range(0.0, 1.0, 0.1);
uniform float dissolve_amount : hint_range(0.0, 1.0, 0.1);

group_uniforms Gradient;
uniform vec4 color_start : source_color = vec4(0.14, 0.63, 0.68, 1.0);
uniform vec4 color_end : source_color = vec4(0.16, 0.52, 0.87, 1.0);
uniform vec3 gradient_dir = vec3(0.0, 1.0, 0.0);
uniform float min_value = -1.0;
uniform float max_value = 1.0;

group_uniforms Fade;
uniform vec4 start_color : source_color = vec4(1.0);
uniform vec4 end_color : source_color = vec4(1.0);
uniform float near_distance : hint_range(0.0, 50.0, 0.1) = 15.0;
uniform float far_distance : hint_range(0.0, 100.0, 0.1) = 100.0;


void fragment()
{
	//Apply directional gradient to object surface
	float gradient_factor = dot(VERTEX, gradient_dir);
	gradient_factor = (gradient_factor - min_value) / (max_value - min_value);
	gradient_factor = clamp(gradient_factor, 0.0, 1.0);
	vec4 gradient_color = mix(color_start, color_end, gradient_factor);
	
	//Calculate distance from camera and apply a fade to the albedo
	vec3 camera_pos = CAMERA_POSITION_WORLD;
	float distance_to_camera = length(camera_pos - NODE_POSITION_WORLD);
	float t = clamp((distance_to_camera - near_distance) / (far_distance - near_distance), 0.0, 1.0);
	vec4 fade_color = mix(gradient_color, end_color, t); // Should start color be gradient_color??
	
	// Mix gradient color and fade color
	vec4 final_color = mix(gradient_color,  fade_color, 0.5);

	ALBEDO = final_color.rgb;
	ALPHA = mix(1.0, 0.0, dissolve_amount);
	ROUGHNESS = roughness;
	METALLIC = metallic;
}
