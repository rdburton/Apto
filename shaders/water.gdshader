shader_type spatial;
render_mode diffuse_toon, specular_toon;
uniform vec4 color : source_color = vec4(0.0);
uniform vec4 peak_color : source_color = vec4(1.0);
uniform vec4 mid_peak_color : source_color = vec4(0.0);
uniform float brightness_threshold = 0.2;
uniform float blend_strength = 1.0;

group_uniforms Waves;
uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform sampler2D noise_normal : repeat_enable, filter_linear;
uniform float noise_scale : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float wave_amp : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float wave_speed : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform vec2 direction = vec2 (0.0, 0.0);
uniform float direction_speed : hint_range(0.0, 1.0);
uniform float mid_peak_min = 0.2;
uniform float mid_peak_max = 0.3;

varying float wave_height;

void vertex()
{
	vec2 offset = direction_speed * direction * TIME;

	vec2 uv = UV * noise_scale;
	float noise_value = texture(noise_texture, UV + offset).r;
	wave_height = sin(TIME * wave_speed + noise_value * 10.0) * wave_amp;
	VERTEX.y += wave_height;

	VERTEX.x += cos(TIME * 1.5 + VERTEX.z * 0.7) * 0.4;
}

void fragment()
{
	vec3 normal_map = texture(noise_normal, UV).rgb * 2.0 - 1.0;
	vec3 adjusted_normal = mix(NORMAL, normal_map, -wave_height * 0.5 + 0.5);
	NORMAL = normalize(adjusted_normal);

    float low_blend = smoothstep(0.0, brightness_threshold, wave_height); // Base color blending
    float mid_blend = smoothstep(mid_peak_min, mid_peak_max, wave_height - 0.6); // Mid peak blending
    float high_blend = smoothstep(brightness_threshold, brightness_threshold + blend_strength, wave_height - 0.01); // Peak color blending

    // Calculate the final color based on height
    vec4 final_color = mix(color, mid_peak_color, mid_blend);
    final_color = mix(final_color, peak_color, high_blend);
	float brightness = clamp(adjusted_normal.y, 0.0, 10.0);
	ALBEDO = final_color.rgb * (0.6 + 0.2 * brightness);
	ALPHA = final_color.a;
}
