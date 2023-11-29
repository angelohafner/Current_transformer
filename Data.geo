mm = 0.01;
DefineConstant
[
	r_int           = 	{ 	2.5	, Name "Toroid Dada/1r_int", 
						Visible 1, 	
						Help "Internal Radius" },

    r_ext           = 	{ 	3.5	, Name "Toroid Dada/2r_ext", 
						Visible 1, 	
						Help "External Radius" },

    ang_gap_inicio  = 	{ 	5.0 , Name "Toroid Dada/3ang_gap_inicio", 
						Visible 1, 	
						Help "Gap Initial Angle" },
						
    ang_gap_fim     = 	{ 	-5.0 , Name "Toroid Dada/4ang_gap_fim", 
						Visible 1, 	
						Help "Gap Final Angle" }

];
r_int = r_int * mm;
r_ext = r_ext * mm;

ang_gap_inicio 	= ang_gap_inicio * Pi / 180;
ang_gap_fim 	= ang_gap_fim 	 * Pi / 180;

rShellInt   = 2*r_ext;
rShellExt   = 1.2*rShellInt;


S_FER = 1000;
S_AIR = 2000;
S_INF = 3000;
S_COND = 4000;

L_FER = 10000;
L_AIR = 20000;
L_INF = 30000;
L_COND = 40000;