struct figure {
	float4 color, color_inner;
	float outer, line_thick, radius;
};
cbuffer constant0 : register(b0) {
	figure fig[4];
	float4 color_back;
	float2x2 to_lattice;
	float2 offset, size;
	float aa_thick;
};
int2 modf_n(float2 pt, out float2 pt_f)
{
	pt_f = frac(pt);
	return int2(round(pt - pt_f));
}
void min_max(float x, float y, out float m, out float M)
{
	if (x < y) { m = x; M = y; }
	else { m = y; M = x; }
}
float aa_step(float x)
{
	return saturate(0.5 + (aa_thick > 0 ? x / aa_thick : sign(x)));
}
float4 mix_color(float dist, float aa_dist, float line_thick, float4 color, float4 color_inner)
{
	const float t1 = aa_step(dist) * aa_step(aa_dist), t2 = aa_step(dist - line_thick);
	return t1 * lerp(color, color_inner, t2);
}
static const float l_size = length(size);
static const float2 flip = { 1, -1 }, n_size = size / l_size;
float4 find_color(float2 pt, float2 slope, uint idx)
{
	pt.x -= slope.x / 2;
	if (dot(pt, slope) > 0) pt *= -1;
	if (dot(pt, flip * slope) > 0) {
		pt = flip * pt.yx;
		slope = slope.yx;
	}
	pt.x += slope.x / 2;
	pt *= l_size;

	float2 u = pt; u.x = u.x - fig[idx].outer / slope.y;
	float dist, aa_dist; min_max(dot(u, slope.yx), dot(u, flip * slope.yx), dist, aa_dist);
	u.x = fig[idx].radius / slope.y - u.x;
	if (all(float2(dot(u, slope), dot(u, flip * slope)) > 0))
		dist = min(dist, fig[idx].radius - length(u));

	return mix_color(dist, aa_dist,
		fig[idx].line_thick, fig[idx].color, fig[idx].color_inner);
}
float4 draw(float4 pos : SV_Position) : SV_Target
{
	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);
	const uint idx = (pt_i.x & 1) | ((pt_i.y & 1) << 1);
	if (pt.x >= 0.5) pt = 1 - pt;
	const float2 slope = pt.y >= 0.5 ? n_size.yx : n_size;
	pt.y = min(pt.y, 1 - pt.y);
	pt = slope * (flip * pt + pt.yx) / 2;

	const float4 col = find_color(pt, slope, idx)
		+ find_color(-flip * pt.yx, slope.yx, idx ^ 1)
		+ find_color(-pt, slope, idx ^ 3)
		+ find_color(flip * pt.yx, slope.yx, idx ^ 2);
	return col + (1 - col.a) * color_back;
}
