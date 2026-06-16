struct figure {
	float4 color, color_inner;
	float outer, line_thick, radius;
};
cbuffer constant0 : register(b0) {
	figure fig[6];
	float4 color_back;
	float2x2 to_lattice;
	float2 offset;
	float aa_thick;
};
int2 modf_n(float2 pt, out float2 pt_f)
{
	pt_f = frac(pt);
	return int2(round(pt - pt_f));
}
int modulo3(int x)
{
	return x < 0 ? 2 - (uint(2 - x) % 3) : uint(x) % 3;
}
float4 draw(float4 pos : SV_Position) : SV_Target
{
	float2 pt;
	const int2 pt_i = modf_n(mul(to_lattice, pos.xy - offset), pt);

	const int idx = (pt.x < pt.y ? 1 : 0) | (modulo3(pt_i.x + pt_i.y) << 1);
	int idx2 = +5;

	if (pt.y > pt.x) pt = float2(1 - pt.x, pt.y - pt.x);
	if (pt.x < 2 * pt.y) {
		pt.y = pt.x - pt.y;
		idx2 = +1;
	}
	if (pt.x + pt.y > 1) {
		pt = float2(1 - pt.y, 1 - pt.x);
		idx2 = +3;
	}
	if (2 * pt.x - pt.y > 1) pt.x = 1 - pt.x + pt.y;

	idx2 = uint(idx + idx2) % 6;
	pt -= fig[idx].outer * float2(2.0, 1.0);
	float dist = pt.y;
	if (2 * pt.x - pt.y < fig[idx].radius) {
		const float
			U = pt.x - pt.y - fig[idx].radius / 3, V = pt.x + pt.y - fig[idx].radius,
			r = sqrt(U * U + V * V / 3);
		dist = min(dist, fig[idx].radius / 3 - r);
	}

	return lerp(lerp(fig[idx].color_inner, fig[idx].color,
		smoothstep(-aa_thick / 2, aa_thick / 2, fig[idx].line_thick - dist)),
		fig[idx].radius <= 0 && fig[idx2].radius <= 0 &&
		fig[idx].outer <= 0 && fig[idx2].outer <= 0 ?
		fig[idx2].color : color_back,
		smoothstep(-aa_thick / 2, aa_thick / 2, -dist));
}
