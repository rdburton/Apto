shader_type spatial;

uniform float roughness : hint_range(0.0, 1.0, 0.1);
uniform float metallic : hint_range(0.0, 1.0, 0.1);

uniform vec4 color_start : source_color = vec4(1.0, 0.6, 0.6, 1.0);
uniform vec4 color_end : source_color = vec4(1.0, 0.85, 0.65, 1.0);
uniform vec3 gradient_dir = vec3(0.0);
uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform float dissolve_pct : hint_range(0.0, 1.0, 0.1) = 0.0;

uniform float min_value = -1.0;
uniform float max_value = 1.0;

void fragment()
{
	float t = dot(VERTEX, gradient_dir);
	t = (t - min_value) / (max_value - min_value);
	t = clamp(t, 0.0, 1.0);
	vec4 color = mix(color_start, color_end, t);
	
	vec4 noise = texture(noise_texture, UV);
	if (dissolve_pct >= noise.r)
	{
		ALPHA = 0.0;
	}
	
	ALBEDO = color.rgb;
	ROUGHNESS = roughness;
	METALLIC = metallic;
}
