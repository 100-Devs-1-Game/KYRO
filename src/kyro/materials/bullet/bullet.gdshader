shader_type spatial;
render_mode shadows_disabled, unshaded, cull_disabled;

const vec3 dither_magic = vec3(0.06711056f, 0.00583715f, 52.9829189f);

uniform sampler2D depth_buffer:hint_depth_texture;

uniform vec3 color_outside: source_color;
uniform vec3 color_core: source_color;

uniform float tracer_dist = 1;
uniform float tracer_thickness = 1.0;
uniform float dither_start = 0.3;
uniform float dither_end = 0.05;




float pixel_dist(mat4 inv_projection_matrix, vec2 screen_uv, vec4 fragcoord) {
	vec4 upos = inv_projection_matrix * vec4(screen_uv * 2.0 - 1.0, fragcoord.z, 1.0);
	vec3 pixel_position = upos.xyz / upos.w;
	return -pixel_position.z;
}


void vertex() {
	VERTEX.y = (VERTEX.y + 0.5) / 2.0 * tracer_dist;
	VERTEX.xz *= tracer_thickness;
}

void fragment() {
	float core_dist = 0.5 - abs(UV.x - 0.5);
	ALBEDO = mix(color_outside, color_core, core_dist);
	
	float depth_remap = pixel_dist(INV_PROJECTION_MATRIX, SCREEN_UV, FRAGCOORD);
	depth_remap = (depth_remap - dither_end) / (dither_start - dither_end);
	if (depth_remap < 0.001 || depth_remap < fract(dither_magic.z * fract(dot(FRAGCOORD.xy, dither_magic.xy)))) {
		discard;
	}
}

