shader_type spatial;
render_mode blend_add;

uniform vec4 color: source_color;
uniform float energy = 1.0;

void fragment() {
	ALBEDO = color.rgb * color.a * energy;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
