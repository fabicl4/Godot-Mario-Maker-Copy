shader_type canvas_item;

// UNIFORMS
// screen resolution
uniform vec2 u_resolution;
// offset from the point of reference
uniform vec2 u_offset;
// space between lines
uniform float u_spacing;
// determines how thick the line is
//uniform float u_line_thickness = 1.0;
// grid alpha value
uniform float u_grid_intensity : hint_range(0.0, 1.0) = 1.0;
// camera zooming
uniform vec2 u_zoom = vec2(1.0, 1.0);
// CONST
// colors
const vec3 c_line_color = vec3(0.0);
const vec3 c_background_color = vec3(1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

// Thick lines 
float grid(vec2 fragCoord, float space, float gridWidth)
{
    vec2 p  = fragCoord - vec2(0.5);
    vec2 size = vec2(gridWidth);
    
    vec2 a1 = mod(p - size, space);
    vec2 a2 = mod(p + size, space);
    vec2 a = a2 - a1;
       
    float g = min(a.x, a.y);
    return clamp(g, 0., 1.0);
}

void fragment() {
	vec2 coord = UV * u_resolution + u_offset*u_zoom;
	vec2 fragCoord = coord - u_resolution/vec2(2.0);
	
	float gridX = mod(fragCoord.x, u_spacing * u_zoom.x);
	float gridY = mod(fragCoord.y, u_spacing * u_zoom.y);
	vec3 col = (gridX < 1.0) || (gridY < 1.0) ? c_line_color : c_background_color;
	//float grid = grid(fragCoord, u_spacing, u_line_thickness);
	//vec3 col = (grid < 1.0) ? c_line_color : c_background_color;
	
    COLOR = vec4(col, u_grid_intensity);
    //COLOR = vec4(SCREEN_UV, 0.0, 1.0);
}