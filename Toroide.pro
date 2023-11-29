Include "Data.geo";


// Defining regions ================================================================================
Group 
{
	S_fer  = #S_FER;
	S_air  = #S_AIR;
	S_inf  = #S_INF;
	S_cond = #S_COND;

	L_inf  = #L_INF;
    
    DomainC_Mag  = Region[{S_cond}];
    DomainCC_Mag = Region[{S_air, S_inf, S_fer}];
    DomainInf 	= 	Region[{S_inf}]; 
    Domain_Mag 	=  Region[{DomainCC_Mag, DomainC_Mag}];
    DomainDummy = #12345; 

    Val_Rint  	= 	rShellInt; 
    Val_Rext  	= 	rShellExt; 	
}

Function 
{
    mu0   = 4*Pi*1e-7;
    nu[S_fer]		= 	1 / (1e4*mu0);
    nu[S_air]		= 	1 / mu0;
    nu[S_cond]		= 	1 / mu0;
    nu[S_inf]		= 	1 / mu0;
    sigma[S_cond]   =   1e7;



    Freq = 1;
    Period = 1/Freq;
    Mag_Time0 = 0.0 ;
    Mag_TimeMax = 1*Period; 
    Mag_DTime[] = Period/64;
    Mag_Theta[] = 1.0;
    
    //Exp[-2000*$Time]
    timeFunction1[] = Cos[2*Pi*Freq*$Time];
	
}		


Constraint 
{
    { 	Name MagneticVectorPotential_2D; // defined in the library
        Case 
        {
            {	Region #L_INF; 	Value 0. ;	}

        }
    }

    { 	Name Current_2D; // defined in the library
        Case
        {				
            { Region S_cond ; Value 1 ; TimeFunction timeFunction1[]; }
        }
    }
}

Include "Integration_Lib.pro";
Include "Jacobian_Lib.pro";
Include "Mag_Sta_Dyn_a_2D.pro";



Resolution
{
    { 	Name Toroid_Analysis;
        System 

        {
            { 	Name Sys_Mag; 
                NameOfFormulation Magnetodynamics_av_2D;
            }
        }
        
        Operation 
        {
			InitSolution Sys_Mag ; 
			SaveSolution Sys_Mag ;
			TimeLoopTheta 
            {	
                Time0 Mag_Time0 ; 
				TimeMax Mag_TimeMax ;  
				DTime Mag_DTime[] ; 
				Theta Mag_Theta[] ;
				Operation 
                {	
                    Generate Sys_Mag ; 
					Solve Sys_Mag ;
					SaveSolution Sys_Mag ;
                    Printf("TEMPORAL FORMULATION");
				}
			}
		}
    }	
}


PostOperation Map_a_a UsingPost MagDyn_av_2D
{
    Print[az, OnElementsOf #{S_fer, S_air}, File "Toroide_a.pos", Format Gmsh];
}
PostOperation Map_a_b UsingPost MagDyn_av_2D 
{
    Print[b, OnElementsOf Domain_Mag, File "Toroide_a_b.pos"] ;
}
PostOperation Map_a_h UsingPost MagDyn_av_2D 
{
    Print[h, OnElementsOf Domain_Mag, File "Toroide_a_h.pos"] ;
}
PostOperation Map_a_j UsingPost MagDyn_av_2D
{
    Print[j , OnElementsOf #{DomainC_Mag, DomainS_Mag}, File "Toroide_a_j.pos"] ;
}





