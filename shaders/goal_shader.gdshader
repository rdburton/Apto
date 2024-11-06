shader_type spatial;
render_mode blend_mix, depth_prepass_alpha;

uniform float roughness : hint_range(0.0, 1.0, 0.1);
uniform float metallic : hint_range(0.0, 1.0, 0.1);

group_uniforms Gradient;
uniform vec4 color_start : source_color = vec4(0.0);
uniform vec4 color_end : source_color = vec4(0.0);
uniform vec3 gradient_dir = vec3(0.0, 1.0, 0.0);
uniform float min_value = -1.0;
uniform float max_value = 1.0;


void fragment()
{
	//Apply directional gradient to object surface
	float gradient_factor = dot(VERTEX, gradient_dir);
	gradient_factor = (gradient_factor - min_value) / (max_value - min_value);
	gradient_factor = clamp(gradient_factor, 0.0, 1.0);
	vec4 gradient_color = mix(color_start, color_end, gradient_factor);

	ALBEDO = gradient_color.rgb;
	ALPHA = gradient_color.a;
	ROUGHNESS = roughness;
	METALLIC = metallic;
}
