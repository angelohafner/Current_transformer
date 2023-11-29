SetFactory("Built-in");
Mesh.Algorithm = 1;
View.NbIso = 101; // Number of intervals
View.IntervalsType = 1; // Type of interval display (1=iso, 2=continuous, 3=discrete, 4=numeric)
View.CenterGlyphs = 0; // Center glyphs (arrows, numbers, etc.)? (0=left, 1=centered, 2=right)

Include "Data.geo";

// Circle generation ============================================================
Function Def_Circle
	// automatic numeration of points
	p1 = newp; 	Point(p1) = {xc_+r_ , yc_    , 0 , p_};
	p2 = newp; 	Point(p2) = {xc_    , yc_+r_ , 0 , p_};
	p3 = newp;  Point(p3) = {xc_-r_ , yc_    , 0 , p_};
	p4 = newp; 	Point(p4) = {xc_    , yc_-r_ , 0 , p_};
	p0 = newp; 	Point(p0) = {xc_    , yc_    , 0 , p_};
	
	// automatic numeration of arcs
	l1 = newl; 	Circle(l1) = {p1 , p0 , p2};
	l2 = newl; 	Circle(l2) = {p2 , p0 , p3};
	l3 = newl; 	Circle(l3) = {p3 , p0 , p4};
	l4 = newl; 	Circle(l4) = {p4 , p0 , p1};

	// Arcs set that gives origin to a circle
	l_[] = {l1,l2,l3,l4};
	// automatic generation of line loops
	ll_ = newl;	Line Loop(ll_) = {l_[]};
	// automatic numeration of surfaces
	s_  = news;	Plane Surface(s_) = {ll_, ll_Holes[]};
Return

//===============================================================================
//===============================================================================
//===============================================================================


lc = r_int/20; // Tamanho da característica da malha
// Ponto central
x0 = 0; 
y0 = 0;

//===============================================================================
// Conductor
r_ 			= 	r_int/10; 
p_ 			= 	lc;
xc_ 		= 	x0; 
yc_ 		= 	y0;
ll_Holes[] 	= 	{};
Call Def_Circle;
l_cond 		= 	l_[];
ll_cond  	= 	ll_;
s_cond  	= 	s_;

//===============================================================================

p0Fe  = newp; Point(p0Fe) = {x0, y0, 0, lc};
// Ponto 1 externo
x_ = x0 + r_int * Cos(ang_gap_inicio) + r_ext - r_int;
y_ = y0 + r_int * Sin(ang_gap_inicio);
p_extFe_1 = newp; Point(p_extFe_1) = {x_, y_, 0, lc};
// Ponto 2 externo
x_ = x0 + r_ext * Cos(ang_gap_inicio+Pi/2);
y_ = y0 + r_ext * Sin(ang_gap_inicio+Pi/2);
p_extFe_2 = newp; Point(p_extFe_2) = {x_, y_, 0, lc};
// Ponto 3 externo
x_ = x0 + r_ext * Cos(ang_gap_inicio-Pi/2);
y_ = y0 + r_ext * Sin(ang_gap_inicio-Pi/2);
p_extFe_3 = newp; Point(p_extFe_3) = {x_, y_, 0, lc};
// Ponto 4 externo
x_ = x0 + r_int * Cos(ang_gap_fim) + r_ext - r_int;
y_ = y0 + r_int * Sin(ang_gap_fim);
p_extFe_4 = newp; Point(p_extFe_4) = {x_, y_, 0, lc};
// Linha 1, 2 e 3 externo
l_extFe_1 = newl; Circle(l_extFe_1) = {p_extFe_1, p0Fe, p_extFe_2};
l_extFe_2 = newl; Circle(l_extFe_2) = {p_extFe_2, p0Fe, p_extFe_3};
l_extFe_3 = newl; Circle(l_extFe_3) = {p_extFe_3, p0Fe, p_extFe_4};
// Ponto inferior interno inicio do circulo que volta por dentro
x_ = x0 + r_int * Cos(ang_gap_fim);
y_ = y0 + r_int * Sin(ang_gap_fim);
p_intFe_1 = newp; Point(p_intFe_1) = {x_, y_, 0, lc};
// Linha reta do externo para o interno parte inferior
l_infFe = newl; Line(l_infFe) = {p_extFe_4, p_intFe_1};
// Pontor interno respectivo do Ponto 3 externo
x_ = x0 + r_int * Cos(ang_gap_inicio-Pi/2);
y_ = y0 + r_int * Sin(ang_gap_inicio-Pi/2);
p_intFe_2 = newp; Point(p_intFe_2) = {x_, y_, 0, lc};
// Pontor interno respectivo do Ponto 2 externo
x_ = x0 + r_int * Cos(ang_gap_inicio-1.2*Pi);
y_ = y0 + r_int * Sin(ang_gap_inicio-1.2*Pi);
p_intFe_3 = newp; Point(p_intFe_3) = {x_, y_, 0, lc};
// Pontor interno respectivo do Ponto 1 externo
x_ = x0 + r_int * Cos(ang_gap_inicio);
y_ = y0 + r_int * Sin(ang_gap_inicio);
p_intFe_4 = newp; Point(p_intFe_4) = {x_, y_, 0, lc};
// Linha 1, 2 e 3 interno
l_intFe_1 = newl; Circle(l_intFe_1) = {p_intFe_1, p0Fe, p_intFe_2};
l_intFe_2 = newl; Circle(l_intFe_2) = {p_intFe_2, p0Fe, p_intFe_3};
l_intFe_3 = newl; Circle(l_intFe_3) = {p_intFe_3, p0Fe, p_intFe_4};
// Linha reta do externo para o interno parte inferior
l_supFe = newl; Line(l_supFe) = {p_intFe_4, p_extFe_1};

l_Fe[] = {l_extFe_1, l_extFe_2, l_extFe_3, l_infFe, l_intFe_1, l_intFe_2, l_intFe_3, l_supFe};
ll_Fe  = newl; Line Loop(ll_Fe)    = {l_Fe[]};
s_Fe   = news; Plane Surface(s_Fe) = {ll_Fe};




// Para cima é o Toróide, para baixo é o ar
//===============================================================================

// AIR
r_ 			= rShellInt; 
p_ 			= 	lc;
xc_ 		= 	x0; 
yc_ 		= 	y0;
ll_temp[] = {ll_cond, ll_Fe};

ll_Holes[] 	= 	{ll_temp[]};
Call Def_Circle;
l_Air 		= 	l_[];
ll_Air 		= 	ll_;
s_Air 		= 	s_;

// AIRINF
r_ 			= 	rShellExt; 
p_ 			= 	lc;
xc_ 		= 	x0; 
yc_ 		= 	y0;
ll_Holes[] 	= 	{ll_Air};
Call Def_Circle;
l_AirInf 	= 	l_[];
ll_AirInf 	= 	ll_;
s_AirInf 	= 	s_;


Physical Surface(S_FER) =   {s_Fe};
Physical Surface(S_AIR) = 	{s_Air};
Physical Surface(S_INF) = 	{s_AirInf};
Physical Surface(S_COND) = 	{s_cond};

Physical Line(L_FER) 	=   {l_Fe[]};
Physical Line(L_AIR) 	= 	{l_Air[]};
Physical Line(L_INF) 	= 	{l_AirInf[]};
Physical Line(L_COND) 	= 	{l_cond[]};
Show "*";