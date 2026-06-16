struct figure {
	float4 color, color_inner;
	float2 outer;
	float line_thick, radius;
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
float aa_step(float x)
{
	return smoothstep(-aa_thick / 2, aa_thick / 2, x);
}
float4 find_color(float2 pt, uint idx)
{
	float2 u = pt - fig[idx].outer;
	float dist = min(u.x, u.y);
	u = fig[idx].radius - u;
	if (all(u > 0)) dist = min(dist, fig[idx].radius - length(u));

	float t1 = aa_step(dist), t2 = aa_step(dist - fig[idx].line_thick);
	if (all(pt < aa_thick / 2)) t1 *= aa_step(max(pt.x, pt.y));
	return t1 * lerp(fig[idx].color, fig[idx].color_inner, t2);
}
float4 draw(float4 pos : SV_Position) : SV_Target
{
	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);
	const uint idx = uint(pt_i.x & 1) | (uint(pt_i.y & 1) << 1);

	pt = min(pt, 1 - pt);
	pt *= size;
	const float4 col = find_color(pt, idx)
		+ find_color(float2(-pt.x, pt.y), idx ^ 1)
		+ find_color(float2(pt.x, -pt.y), idx ^ 2)
		+ find_color(float2(-pt.x, -pt.y), idx ^ 3);
	return col + (1 - col.a) * color_back;
}
