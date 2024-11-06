shader_type spatial;
render_mode unshaded, blend_mix;

uniform vec4 color : source_color = vec4(0.0);

group_uniforms Dissolve;
uniform sampler2D  dissolve_texture : repeat_enable, filter_linear;
uniform float dissolve_threshold : hint_range(0.0, 1.0) = 0.0;

group_uniforms Wave;
uniform sampler2D noise_texture : repeat_enable, filter_linear;
uniform float noise_scale : hint_range(0.0, 1.0) = 0.2;
uniform float wave_amp : hint_range(0.0, 1.0) = 0.2;
uniform float wave_speed : hint_range(0.0, 1.0) = 0.2;

void vertex()
{
	vec2 uv = UV * noise_scale;
	float noise_value = texture(noise_texture, UV).r;
	float wave = sin(TIME * wave_speed + noise_value * 10.0) * wave_amp;
	VERTEX.y += wave;
}

void fragment()
{
	vec2 uv = UV;

	float dissolve_value = texture(dissolve_texture, uv).r;

	if (dissolve_value < dissolve_threshold)
	{
		ALPHA = 0.0;
	}
	else
		{
			ALPHA = color.a;
		}

	ALBEDO = color.rgb;

}
