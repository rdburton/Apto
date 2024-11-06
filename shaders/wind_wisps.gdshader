shader_type spatial;
render_mode unshaded, cull_disabled;

uniform vec4 color1 : source_color = vec4(0.0);
uniform vec4 color2 : source_color = vec4(0.0);
uniform vec4 color3 : source_color = vec4(0.0);
uniform float gradient_height = 1.0;
uniform float pinch_strength = 0.5;

void vertex()
{
	VERTEX.y += sin(TIME * -0.5 + VERTEX.x * 0.7) * 0.2;
	VERTEX.y += sin(TIME * -0.5 + VERTEX.z * 0.7) * 0.2;

	float pinch_factor = 1.0 - (abs(VERTEX.y) / gradient_height) * pinch_strength;
	VERTEX.y *= pinch_factor;
}

void fragment()
{
	float uv_factor = clamp(UV.x / gradient_height, 0.0, 1.0);

	vec4 color;
	if (uv_factor < 0.5)
	{
		color = mix(color1, color2, uv_factor * 2.0);
	}
	else
	{
		color = mix(color2, color3, (uv_factor - 0.5) * 2.0);
	}
	ALBEDO = color.rgb;
	ALPHA = color.a;
}
