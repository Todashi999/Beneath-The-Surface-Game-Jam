shader_type canvas_item;

uniform float time_speed : hint_range(0.0, 10.0) = 1.0;
uniform float brightness : hint_range(0.0, 5.0) = 1.5;

uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);
uniform vec3 shadow_color : source_color = vec3(0.0, 0.0, 0.0); // formerly black

void fragment() {
    float pulse = 0.5 + 0.5 * sin(TIME * time_speed + UV.x * 10.0 + UV.y * 10.0);

    // You can change this blend however you want
    vec3 color_mix = mix(shadow_color, tint_color, pulse);

    COLOR.rgb *= color_mix * brightness;
}
