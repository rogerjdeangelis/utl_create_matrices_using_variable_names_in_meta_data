Create matrices based on a reference table and separate data                                                                            
                                                                                                                                        
see                                                                                                                                     
https://goo.gl/bNnUfH                                                                                                                   
https://communities.sas.com/t5/SAS-IML-Software-and-Matrix/Create-matrices-based-on-a-reference-table-and-separate-data/m-p/423559      
                                                                                                                                        
INPUT                                                                                                                                   
=====                                                                                                                                   
                                                                                                                                        
 * meta data for rearanging data;                                                                                                       
 WORK.META    |                                                                                                                         
              |                                                                                                                         
   FIELDNAME  |   RULES                                                                                                                 
              |   The key to the algorithm is creating the array statement at compile time                                              
      _11     |                                                                                                                         
      XYZ     |   array mat[3,3] _11 XYZ ABC _21 PQR MNO AB PQ _33;                                                                     
      ABC     |                                                                                                                         
      _21     |   For instance ( values in cells are arbitrary)                                                                         
      PQR     |                                                                                                                         
      MNO     |         0      11     12        0(not in data )   11(XYZ)   12(ABC)                                                     
      AB      |         0      13     14        0(not in data )   13(PQR)   14(MNO)                                                     
      PQ      |         15     16      0        15(AB)            16(PQ)     0(not in data)                                             
      _33     |                                                                                                                         
                                                                                                                                        
                                                                                                                                        
  WORK.HAVE total obs=2                                                                                                                 
                                                                                                                                        
      XYZ   ABC    PQR    MNO    AB    PQ                                                                                               
                                                                                                                                        
       11    12     13     14    15    16                                                                                               
       22    21     23     24    25    26                                                                                               
                                                                                                                                        
PROCESS  WORKING CODE                                                                                                                   
========================                                                                                                                
                                                                                                                                        
      COMPILE time dosubl                                                                                                               
                                                                                                                                        
        select fieldname into :variables separated by " "                                                                               
        from sd1.meta;                                                                                                                  
                                                                                                                                        
        array mat[3,3] &variables;                                                                                                      
                                                                                                                                        
      EXECUTION TIME                                                                                                                    
                                                                                                                                        
      set sd1.have;                                                                                                                     
                                                                                                                                        
OUTPUT                                                                                                                                  
======                                                                                                                                  
                                                                                                                                        
     0      11     12                                                                                                                   
     0      13     14                                                                                                                   
     15     16      0                                                                                                                   
                                                                                                                                        
                                                                                                                                        
     0      21     22                                                                                                                   
     0      23     24                                                                                                                   
    25      26      0                                                                                                                   
                                                                                                                                        
*                _              _       _                                                                                               
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _                                                                                        
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |                                                                                       
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |                                                                                       
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|                                                                                       
                                                                                                                                        
;                                                                                                                                       
                                                                                                                                        
data sd1.meta;                                                                                                                          
   input    FIELDNAME$;                                                                                                                 
cards4;                                                                                                                                 
 _11                                                                                                                                    
 XYZ                                                                                                                                    
 ABC                                                                                                                                    
 _21                                                                                                                                    
 PQR                                                                                                                                    
 MNO                                                                                                                                    
 AB                                                                                                                                     
 PQ                                                                                                                                     
 _33                                                                                                                                    
;;;;                                                                                                                                    
run;quit;                                                                                                                               
                                                                                                                                        
data sd1.have;                                                                                                                          
 input  XYZ ABC PQR MNO AB PQ ;                                                                                                         
cards4;                                                                                                                                 
 11 12 13 14 15 16                                                                                                                      
 21 22 23 24 25 26                                                                                                                      
;;;;                                                                                                                                    
run;quit;                                                                                                                               
                                                                                                                                        
*                          _       _   _                                                                                                
 ___  __ _ ___   ___  ___ | |_   _| |_(_) ___  _ __                                                                                     
/ __|/ _` / __| / __|/ _ \| | | | | __| |/ _ \| '_ \                                                                                    
\__ \ (_| \__ \ \__ \ (_) | | |_| | |_| | (_) | | | |                                                                                   
|___/\__,_|___/ |___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                                   
                                                                                                                                        
;                                                                                                                                       
                                                                                                                                        
options missing=0;                                                                                                                      
data want;                                                                                                                              
                                                                                                                                        
  * create array at compile time;                                                                                                       
  If _n_=0 then do;                                                                                                                     
     %let rc=%sysfunc(dosubl('                                                                                                          
          proc sql;                                                                                                                     
            select fieldname into :variables separated by " "                                                                           
            from sd1.meta;                                                                                                              
          ;quit;                                                                                                                        
     '));                                                                                                                               
     array mat[3,3] &variables;                                                                                                         
  end;                                                                                                                                  
                                                                                                                                        
  set sd1.have;                                                                                                                         
                                                                                                                                        
  do i=1 to 3;                                                                                                                          
    put @2 mat[i,1] @5 mat[i,2] @9 mat[i,3];                                                                                            
  end;                                                                                                                                  
                                                                                                                                        
run;quit;                                                                                                                               
                              
