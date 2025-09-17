shader_type spatial;
render_mode cull_disabled, blend_add, unshaded;

uniform sampler2D depth_tex: hint_depth_texture;

uniform sampler2D noise;
uniform sampler2D height_grad;
uniform vec3 tint: source_color = vec3(1.0);
uniform vec2 scroll_offset;
uniform vec2 scroll_rate = vec2(0.0, 1.0);

varying float y_scale;
varying float height;

void vertex() {
	y_scale = MODEL_MATRIX[1][1];
	height = VERTEX.y;
}

void fragment() {
	vec2 uv = vec2(UV.x, UV.y * y_scale);
	uv += scroll_rate * TIME + scroll_offset;
	
	vec4 height_col = texture(height_grad, vec2(height));
	// treating this thing as floats because red is the only real data channel
	height_col.a = clamp(height_col.r, 0.0, 1.0);
	height_col.b = height_col.r - height_col.a;
	height_col.r = height_col.a;
	vec4 noise_col = texture(noise, uv) * height_col.r + height_col.b;
	
	ALBEDO = noise_col.rgb * noise_col.a * tint;
}
