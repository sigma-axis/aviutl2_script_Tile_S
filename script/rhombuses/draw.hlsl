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
float4 draw(float4 pos : SV_Position) : SV_Target
{
	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);

	const int idx = uint(pt_i.x & 1) | (uint(pt_i.y & 1) << 1);
	int idx2 = idx ^ 2;

	float2 sz2 = size * size;
	float N = sz2.x + sz2.y, D = sz2.x - sz2.y;
	if (pt.x + pt.y > 1) pt = 1 - pt;
	if (pt.x < pt.y) {
		pt = float2(pt.y, pt.x);
		idx2 ^= 3;
	}
	if (N * pt.x + D * pt.y > sz2.x) {
		pt.x = 1 - pt.x;
		sz2 = float2(sz2.y, sz2.x);
		D = -D;
	}

	pt -= fig[idx].outer;
	float dist = pt.y;
	if (N * pt.x + D * pt.y < sz2.x * fig[idx].radius) {
		const float U = pt.x + pt.y - fig[idx].radius, V = pt.x - pt.y,
			r = sqrt((N / 4) * (U * U / sz2.y + V * V / sz2.x));
		dist = min(dist, fig[idx].radius / 2 - r);
	}

	return lerp(lerp(fig[idx].color_inner, fig[idx].color,
		smoothstep(-aa_thick / 2, aa_thick / 2, fig[idx].line_thick - dist)),
		fig[idx].radius <= 0 && fig[idx2].radius <= 0 &&
		fig[idx].outer <= 0 && fig[idx2].outer <= 0 ?
		fig[idx2].color : color_back,
		smoothstep(-aa_thick / 2, aa_thick / 2, -dist));
}
