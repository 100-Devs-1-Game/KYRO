shader_type spatial;
render_mode unshaded, blend_add;

uniform vec4 color: source_color;
uniform vec3 highlight_band_color: source_color = vec3(0.5);
uniform float highlight_band_period = 1.0;
uniform float highlight_band_width = 0.5;


void fragment() {
	ALBEDO = color.rgb * color.a;
	
	vec3 view_corrected = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	ALBEDO = color.rgb * color.a;

	vec2 coord = view_corrected.xy;
	
	if(mod((coord.x + coord.y - TIME), highlight_band_period) < highlight_band_width){
		ALBEDO += highlight_band_color;
	}
}