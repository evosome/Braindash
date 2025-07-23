shader_type canvas_item;

uniform float vignette_size : hint_range(0.0, 1.0) = 0.7; // Размер центрального квадрата
uniform float vignette_softness : hint_range(0.01, 0.5) = 0.1; // Мягкость перехода
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);

void fragment() {
    vec2 uv = UV * 2.0 - 1.0; // [-1, 1]
    float edge = vignette_size;

    // Для каждой оси считаем затенение за пределами квадрата
    float vignette_x = smoothstep(edge, edge + vignette_softness, abs(uv.x));
    float vignette_y = smoothstep(edge, edge + vignette_softness, abs(uv.y));

    // Объединяем затенение по осям: если хотя бы по одной оси за пределами — затемняем
    float vignette = max(vignette_x, vignette_y);

    // Смешиваем цвета
    COLOR = vec4(vignette_color.rgb, vignette * vignette_color.a);
}