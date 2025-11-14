shader_type canvas_item;

uniform float time_speed = 1.0;
uniform float brightness = 1.5;

void fragment() {
	float pulse = 0.5 + 0.5 * sin(TIME * time_speed + UV.x * 10.0 + UV.y * 10.0);
	COLOR.rgb *= brightness * pulse;
}
