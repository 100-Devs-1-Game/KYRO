shader_type spatial;
render_mode cull_disabled;

uniform vec4 albedo: source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float metallic: hint_range(0.0, 1.0, 0.01);
uniform float specular: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float roghness: hint_range(0.0, 1.0, 0.01);
uniform float vertex_jiggle_amount = 1.0;

float rand(vec2 n){
	return fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

mat3 rotate_z(float theta) {
	float c = cos(theta);
	float s = sin(theta);
	return mat3(
		vec3(c, -s, 0),
		vec3(s, c, 0),
		vec3(0, 0, 1)
	);
}


void vertex() {
	VERTEX.x += rand(VERTEX.xy + vec2(float(INSTANCE_ID), 0.0)) * vertex_jiggle_amount;
	VERTEX.y += rand(VERTEX.xy + vec2(0.0, float(INSTANCE_ID))) * vertex_jiggle_amount;
	VERTEX.z += rand(VERTEX.xy) * vertex_jiggle_amount;
	VERTEX *= rotate_z(rand(VERTEX.xy + vec2(float(INSTANCE_ID * 2), 0.0)));
}

void fragment() {
	ALBEDO = albedo.rgb;
	METALLIC = metallic;
	SPECULAR = specular;
	ROUGHNESS = roghness;
	ALPHA = albedo.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
