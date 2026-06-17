struct figure {
	float4 color, color_inner;
	float outer, line_thick, radius;
};
cbuffer constant0 : register(b0) {
	figure fig[3];
	float4 color_back;
	float2x2 to_lattice;
	float2 offset;
	float size, aa_thick;
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
	return smoothstep(-aa_thick / 2, aa_thick / 2, x);
}
float4 mix_color(float dist, float line_thick, float4 color, float4 color_inner)
{
	const float t1 = aa_step(dist), t2 = aa_step(dist - line_thick);
	return t1 * lerp(color, color_inner, t2);
}
float4 find_color(float2 pt, uint idx)
{
	static const float2
		vec_offset = { 1 / sqrt(3), 1 },
		vec_normal = { sqrt(3) / 2, 0.5 },
		vec_tangent = { -0.5, sqrt(3) / 2 };
	float2 u = pt - fig[idx].outer * vec_offset;
	float dist = min(dot(vec_normal, u), u.y);
	u = fig[idx].radius * vec_offset - u;
	if (all(float2(u.x, dot(u, vec_tangent)) > 0))
		dist = min(dist, fig[idx].radius - length(u));

	return mix_color(dist,
		fig[idx].line_thick, fig[idx].color, fig[idx].color_inner);
}
uint modulo3(int x)
{
	return uint(x + 0x7ffffffe) % 3; // incorrect exceptions at x = -2^31, -2^31+1 (unlikely occur).
}
float4 draw(float4 pos : SV_Position) : SV_Target
{
	static const float2x2 to_triangle = { 1, -0.5, 0, sqrt(3) / 2 };
	static const float2 n[3] = {
		{ 0, 0 },
		{ 0, 1 },
		{ 0.5, sqrt(3) / 2 },
	};

	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);
	uint3 idx = { 0, 1, 2 };
	idx += modulo3(dot(pt_i, int2(1, -1)));
	switch (modulo3(dot(pt_i, 1))) {
	case 0: break;
	case 1:
		if (pt.x > pt.y) {
			idx += 2;
			idx.yz = idx.zy;
			pt = pt.yx;
		}
		pt.x = dot(pt, float2(-1, 1));
		idx += 2;
		break;
	case 2:
		pt = 1 - pt.yx;
		break;
	}
	if (pt.x < pt.y) {
		pt = pt.yx;
		idx.yz = idx.zy;
	}
	if (dot(pt, float2(2, -1)) > 1)
		pt.x = 1 - pt.x + pt.y;
	idx %= 3;

	pt = size * mul(to_triangle, pt);
	const float4 col = find_color(pt, idx[0])
		+ find_color(pt - 2 * dot(pt, n[1]) * n[1], idx[1])
		+ find_color(pt - 2 * dot(pt, n[2]) * n[2], idx[2]);
	return col + (1 - col.a) * color_back;
}
