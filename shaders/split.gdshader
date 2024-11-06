shader_type spatial;

uniform vec4 outline_color : source_color = vec4(0.0);
uniform float outline_width = 0.05;

void vertex()
{
	VERTEX += NORMAL * outline_width;
}

void fragment()
{
	ALBEDO = outline_color.rgb;
	ALPHA = outline_color.a;
}