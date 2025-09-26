shader_type canvas_item;

uniform float scroll_speed = 50;
uniform float character_width = 17;

void vertex() {
	float period = float(COLOR.r) * character_width;
	COLOR = vec4(1.0);
	float offset = 0.0;
	if (VERTEX_ID > 1){
		offset += character_width;
	}
	float position = float(INSTANCE_ID) * character_width + TIME * scroll_speed;
	
	position = mod(position, period);
	VERTEX.x = position + offset;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

