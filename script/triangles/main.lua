--information:三角タイルσ@Tile_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Tile_S
--require:${LEAST_AVIUTL_VERSION}
---$track:幅, min = 0, max = 4000, step = 1, scale = 0.25
local width = 320

---$track:高さ, min = 0, max = 4000, step = 1, scale = 0.25
local height = 320

---$checksection:背景サイズ
local screen_size = false

---$select:タイル種類
---1種類 = 0
---2種類 = 1
---3種類 = 2
---6種類 = 3
local limit_tiles = 3

--group:色設定,false
---$color:色1
local col1 = 0xffffff

---$color:内部色1
local col_inner1 = 0xa0a0a0

---$color:色2
local col2 = 0xe0e0e0

---$color:内部色2
local col_inner2 = 0x808080

---$color:色3
local col3 = 0xc0c0c0

---$color:内部色3
local col_inner3 = 0x606060

---$color:色4
local col4 = 0xa0a0a0

---$color:内部色4
local col_inner4 = 0x404040

---$color:色5
local col5 = 0x808080

---$color:内部色5
local col_inner5 = 0x202020

---$color:色6
local col6 = 0x606060

---$color:内部色6
local col_inner6 = 0x000000

---$color:余白色
local col_back = 0x808080

---$track:透明度1, min = 0, max = 100, step = 0.01
local alpha1 = 0

---$track:透明度2, min = 0, max = 100, step = 0.01
local alpha2 = 0

---$track:透明度3, min = 0, max = 100, step = 0.01
local alpha3 = 0

---$track:透明度4, min = 0, max = 100, step = 0.01
local alpha4 = 0

---$track:透明度5, min = 0, max = 100, step = 0.01
local alpha5 = 0

---$track:透明度6, min = 0, max = 100, step = 0.01
local alpha6 = 0

---$track:余白透明度, min = 0, max = 100, step = 0.01
local alpha_back = 100

--group:タイル設定,false
---$track:マス幅, min = 1, max = 2000, step = 0.01, scale = 0.25
local block = 64

---$track:ライン幅, min = 0, max = 1000, step = 0.01, scale = 0.25
local line = 1000

---$track:角半径, min = 0, max = 1000, step = 0.01, scale = 0.25
local radius = 0

---$track:余白幅, min = 0, max = 2000, step = 0.01, scale = 0.25
local back = 0

--group:タイル配置,false
---$track:回転, min = -3600, max = 3600, step = 0.01, scale = 0.1
local rotate = 0

---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

--trackgroup@X,Y:tile_pos
--group:その他,false
---$checksection:アンチエイリアス
local antialias = true

---$value:PI
local PI = {}

--[[pixelshader@draw:
---$include "draw.hlsl"
]]
local obj, tonumber, type, math, bit = obj, tonumber, type, math, require("bit");

-- set anchors.
obj.setanchor("X,Y", 0, "line");

--#region PI / normalize parameters.

--take parameters.
--[==[
	PI = {
		width:			number?,
		height:			number?,
		screen_size:	boolean|number|nil,
		limit_tiles:	string?,
		col:			table|number|nil,
		col_inner:		table|number|nil,
		alpha:			table|number|nil,
		block:			number?,
		line:			table|number|nil,
		radius:			table|number|nil,
		col_back:		number?,
		alpha_back:		number?,
		back:			table|number|nil,
		rotate:			number?,
		X:				number?,
		Y:				number?,
		antialias:		boolean|number|nil,
	}
--]==]
local function field_as_num(src, tgt, fld)
	local t = src[fld];
	if type(t) == "table" then
		tgt[1][fld], tgt[2][fld], tgt[3][fld], tgt[4][fld], tgt[5][fld], tgt[6][fld] =
			tonumber(t[1]) or tgt[1][fld],
			tonumber(t[2]) or tgt[2][fld],
			tonumber(t[3]) or tgt[3][fld],
			tonumber(t[4]) or tgt[4][fld],
			tonumber(t[5]) or tgt[5][fld],
			tonumber(t[6]) or tgt[6][fld];
	elseif type(t) == "number" then
		tgt[1][fld], tgt[2][fld], tgt[3][fld], tgt[4][fld], tgt[5][fld], tgt[6][fld] = t, t, t, t, t, t;
	end
end
local function as_bool(t, v)
	if type(t) == "boolean" then return t;
	elseif type(t) == "number" then return t ~= 0;
	else return v end
end
local fig = {
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col1, col_inner = col_inner1, alpha = alpha1, },
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col2, col_inner = col_inner2, alpha = alpha2, },
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col3, col_inner = col_inner3, alpha = alpha3, },
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col4, col_inner = col_inner4, alpha = alpha4, },
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col5, col_inner = col_inner5, alpha = alpha5, },
	{ line = line, radius = radius, back = back, r = 0.0, g = 0.0, b = 0.0, r_i = 0.0, g_i = 0.0, b_i = 0.0, col = col6, col_inner = col_inner6, alpha = alpha6, },
};
width = tonumber(PI.width) or width;
height = tonumber(PI.height) or height;
screen_size = as_bool(PI.screen_size, screen_size);
if type(PI.limit_tiles) == "string" then
	local name2num = { ["1種類"] = 0, ["2種類"] = 1, ["3種類"] = 2, ["6種類"] = 3 };
	limit_tiles = name2num[PI.limit_tiles] or limit_tiles;
end
field_as_num(PI, fig, "col");
field_as_num(PI, fig, "col_inner");
field_as_num(PI, fig, "alpha");
block = tonumber(PI.block) or block;
field_as_num(PI, fig, "line");
field_as_num(PI, fig, "radius");
col_back = tonumber(PI.col_back) or col_back;
alpha_back = tonumber(PI.alpha_back) or alpha_back;
field_as_num(PI, fig, "back");
rotate = tonumber(PI.rotate) or rotate;
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
antialias = as_bool(PI.antialias, antialias);

-- normalize parameters.
if screen_size then
	width, height = obj.screen_w, obj.screen_h;
else
	width = math.max(math.floor(0.5 + width), 0);
	height = math.max(math.floor(0.5 + height), 0);
end
limit_tiles = math.min(math.max(math.floor(0.5 + limit_tiles), 0), 3);
for i = 1, #fig do
	local f = fig[i];
	f.col = math.floor(0.5 + f.col) % 2 ^ 24;
	f.col_inner = math.floor(0.5 + f.col_inner) % 2 ^ 24;
	f.alpha = math.min(math.max(1 - f.alpha / 100, 0), 1);
	f.line = math.max(f.line, 0);
	f.radius = math.max(f.radius, 0);
	f.back = math.max(f.back, 0);
end
block = math.max(block, 1);
col_back = math.floor(0.5 + col_back) % 2 ^ 24;
alpha_back = math.min(math.max(1 - alpha_back / 100, 0), 1);
rotate = 2 * math.pi * ((rotate / 360) % 1);
local dx, dy = X + width / 2, Y + height / 2;

--#endregion PI / normalize parameters.

-- further calculations.
local function rgb(col, alpha)
	return
		alpha * (bit.band(col, 0xff0000) / 0xff0000),
		alpha * (bit.band(col, 0x00ff00) / 0x00ff00),
		alpha * (bit.band(col, 0x0000ff) / 0x0000ff);
end
local function col_pair(l, col_o, col_i, alpha)
	-- remove artifacts when line width is near 0.
	local t = l < 1 and 6 * l / (5 * l + 1) or 1;
	local r_o, g_o, b_o = rgb(col_o, alpha);
	local r_i, g_i, b_i = rgb(col_i, alpha);
	return
		t * r_o + (1 - t) * r_i,
		t * g_o + (1 - t) * g_i,
		t * b_o + (1 - t) * b_i,
		r_i, g_i, b_i;
end
for i = 1, #fig do
	local f = fig[i];
	f.r, f.g, f.b, f.r_i, f.g_i, f.b_i = col_pair(f.line, f.col, f.col_inner, f.alpha);
	f.back = math.min(f.back / 2, block / (2 * 3 ^ 0.5));
	f.radius = math.min(f.radius, block / (2 * 3 ^ 0.5) - f.back);
end
if limit_tiles == 0 then fig[2], fig[3], fig[4], fig[5], fig[6] = fig[1], fig[1], fig[1], fig[1], fig[1];
elseif limit_tiles == 1 then fig[3], fig[4], fig[5], fig[6] = fig[1], fig[2], fig[1], fig[2];
elseif limit_tiles == 2 then fig[4], fig[5], fig[6] = fig[1], fig[2], fig[3] end
local r_bk, g_bk, b_bk = rgb(col_back, alpha_back);

local m11, m12, m21, m22 =
	1, -1 / 3 ^ 0.5,
	0, -2 / 3 ^ 0.5 do
	local c, s = math.cos(rotate) / block, math.sin(rotate) / block;
	m11, m12, m21, m22 =
		-- multiplication of M * (rotation matrix).
		m11 * c - m12 * s, m11 * s + m12 * c,
		m21 * c - m22 * s, m21 * s + m22 * c;
end

-- draw by shader.
obj.clearbuffer("object", width, height);
obj.pixelshader("draw", "object", nil, {
	fig[1].r,   fig[1].g,   fig[1].b,   fig[1].alpha;
	fig[1].r_i, fig[1].g_i, fig[1].b_i, fig[1].alpha;
	fig[1].back, fig[1].line, fig[1].radius, 0;

	fig[5].r,   fig[5].g,   fig[5].b,   fig[5].alpha;
	fig[5].r_i, fig[5].g_i, fig[5].b_i, fig[5].alpha;
	fig[5].back, fig[5].line, fig[5].radius, 0;

	fig[3].r,   fig[3].g,   fig[3].b,   fig[3].alpha;
	fig[3].r_i, fig[3].g_i, fig[3].b_i, fig[3].alpha;
	fig[3].back, fig[3].line, fig[3].radius, 0;

	fig[2].r,   fig[2].g,   fig[2].b,   fig[2].alpha;
	fig[2].r_i, fig[2].g_i, fig[2].b_i, fig[2].alpha;
	fig[2].back, fig[2].line, fig[2].radius, 0;

	fig[4].r,   fig[4].g,   fig[4].b,   fig[4].alpha;
	fig[4].r_i, fig[4].g_i, fig[4].b_i, fig[4].alpha;
	fig[4].back, fig[4].line, fig[4].radius, 0;

	fig[6].r,   fig[6].g,   fig[6].b,   fig[6].alpha;
	fig[6].r_i, fig[6].g_i, fig[6].b_i, fig[6].alpha;
	fig[6].back, fig[6].line, fig[6].radius, 0;

	r_bk, g_bk, b_bk, alpha_back;

	m11, m21, 0, 0,
	m12, m22;

	dx, dy; block; antialias and 1 or 0;
});
