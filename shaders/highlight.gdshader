shader_type spatial;

uniform vec4 color : source_color = vec4(0.0);
uniform vec4 outline_color : source_color = vec4(0.0);
uniform float outline_intensity : hint_range(0.0, 5.0, 0.1) = 1.0;
uniform float outline_power : hint_range(0.0, 5.0, 0.1) = 2.0;

void fragment()
{
	float fresnel = pow(1.0 - dot(NORMAL, VIEW), outline_power);
	
	ALBEDO = mix(color.rgb, outline_color.rgb, fresnel * outline_intensity);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
