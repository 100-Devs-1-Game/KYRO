shader_type spatial;

uniform vec4 color_1: source_color = vec4(1.0, 1.0 , 1.0, 1.0);
uniform vec4 color_2: source_color = vec4(0.0, 0.0 , 0.0, 1.0);
uniform sampler2D fade_taper: source_color, filter_linear, repeat_disable;
uniform float fade_taper_length = 0.5;
uniform float checker_scale = 1.0;
uniform vec2 scroll_rate = vec2(0.25, 0.0);


void vertex() {
	UV2 = VERTEX.xy;
}

void fragment() {
	// Checkerboard
	vec2 coords = UV2 / checker_scale + scroll_rate * TIME;
	float selector = mod(
		floor(coords.x) + floor(coords.y), 2.0
	);
	vec4 color = mix(color_1, color_2, selector);
	
	
	float cabs_uvx = abs(UV.x - 0.5) * 2.0; // Centered Absolute UV x
	float xscale = abs((UV2.x / cabs_uvx));
	float normalized_fade_taper = fade_taper_length / xscale;
	
	//// Fading
	// there's probably a better way to get this
	float value = 
	max((cabs_uvx - (1.0 - normalized_fade_taper)) * (1.0 / normalized_fade_taper), 0.0);
	color *= texture(fade_taper, vec2(value, 0.0));

	//color = texture(
		//fade_taper,
		//vec2(abs(UV.x - 0.5) * 2.0)
	//);
	
	ALBEDO = color.rgb;
	ALPHA = color.a;
}

