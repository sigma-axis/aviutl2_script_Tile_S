struct figure {
	float4 color, color_inner;
	float outer, line_thick, radius;
};
cbuffer constant0 : register(b0) {
	figure fig[6];
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
float aa_step(float x)
{
	return saturate(0.5 + (aa_thick > 0 ? x / aa_thick : sign(x)));
}
float4 mix_color(float dist, float line_thick, float4 color, float4 color_inner)
{
	const float t1 = aa_step(dist), t2 = aa_step(dist - line_thick);
	return t1 * lerp(color, color_inner, t2);
}
float4 find_color(float2 pt, uint idx, inout float sum_weight)
{
	static const float2
		vec_offset = { sqrt(3), 1 },
		vec_normal = { sqrt(3) / 2, -0.5 };
	float2 u = pt - fig[idx].outer * vec_offset;
	float dist = min(dot(vec_normal, u), u.y);
	if (fig[idx].radius > 0) {
		const float2 v = fig[idx].radius * vec_offset - u;
		if (all(float2(v.x, dot(v, vec_offset.yx / 2)) > 0))
			dist = min(dist, fig[idx].radius - length(v));
	}

	sum_weight += aa_step(min(dot(vec_normal, pt), pt.y));
	return mix_color(dist, fig[idx].line_thick, fig[idx].color, fig[idx].color_inner);
}
uint modulo3(int x)
{
	return uint(x + 0x7ffffffe) % 3; // incorrect exceptions at x = -2^31, -2^31+1 (unlikely occur).
}
float4 draw(float4 pos : SV_Position) : SV_Target
{
	static const float2x2 to_triangle = { 1, -0.5, 0, sqrt(3) / 2 };
	static const float2 n[6] = {
		{ sqrt(3) / 2, -0.5 },
		{ 0, 0 },
		{ 0, 1 },
		{ 0.5, sqrt(3) / 2 },
		{ sqrt(3) / 2, 0.5 },
		{ 1, 0 },
	};

	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);

	uint3 idx1 = { 0, 2, 1 }, idx2;
	idx1 += modulo3(dot(pt_i, 1)); idx1 %= 3; idx2 = idx1 + 3;

	if (pt.x < pt.y) {
		pt = pt.yx;
		uint3 t = idx1; idx1 = idx2; idx2 = t;
	}
	if (dot(pt, 1) > 1) {
		pt = 1 - pt.yx;
		idx1.yz = idx1.zy;
		idx2.yz = idx2.zy;
	}
	if (dot(pt, float2(2, -1)) > 1) {
		pt.x = 1 - pt.x + pt.y;
		idx1.xz = idx1.zx;
		idx2.yz = idx2.zy;
	}

	pt = size * mul(to_triangle, pt);
	float sum_weight = 0;
	float4 col = find_color(pt, idx2[0], sum_weight)
		+ find_color(pt - 2 * dot(pt, n[0]) * n[0], idx1[0], sum_weight)
		+ find_color(pt - 2 * dot(pt, n[2]) * n[2], idx1[1], sum_weight)
		+ find_color(pt - 2 * dot(pt, n[3]) * n[3], idx2[2], sum_weight)
		+ find_color(pt - 2 * dot(pt, n[4]) * n[4], idx1[2], sum_weight)
		+ find_color(pt - 2 * dot(pt, n[5]) * n[5], idx2[1], sum_weight);
	col /= sum_weight;
	return col + (1 - col.a) * color_back;
}
