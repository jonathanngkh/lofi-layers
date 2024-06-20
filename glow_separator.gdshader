shader_type canvas_item;
render_mode unshaded;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment() {
	COLOR = clamp(textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0), 0.0, 1.0);
}