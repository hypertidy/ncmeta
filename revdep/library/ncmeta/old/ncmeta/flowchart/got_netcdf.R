## remotes::install_cran("DiagrammeR)
library(DiagrammeR)

grViz("digraph flowchart {
      # node definitions with substituted label text
      node [fontname = Helvetica, shape = rectangle]        
      
      tab1 [label = '@@1']
      tab2 [label = '@@2']
      tab3 [label = '@@3']
      tab4 [label = '@@4']
      tab5 [label = '@@5']
      tab6 [label = '@@6']
      tab7 [label = '@@7']
      tab8 [label = '@@8']
      tab9 [label = '@@9']
      tab10 [label = '@@10']
      tab11 [label = '@@11']
      tab12 [label = '@@12']
      tab13 [label = '@@13']
      tab14 [label = '@@14']
      tab15 [label = '@@15']
    
      # edge definitions with the node IDs
      tab2 -> tab15 -> tab1; 
      tab1 -> tab2;
      tab1 -> tab3;
      tab3 -> tab4;
      tab4 -> tab5 -> tab6; 
      tab4 -> tab7; 
      tab7 -> tab8; 
      tab8 -> tab9; 
      tab8 -> tab10; 
      tab10 -> tab11;
      tab9 -> tab12;
      tab12 -> tab13; 
      tab12 -> tab14;
      }

      [1]: 'Got NetCDF?'
      [2]: 'No'
      [3]: 'Yes \\nraster(thefile)'
      [4]: 'ERROR: cells are not equally spaced ?'
      [5]: 'No'
      [6]: 'raster(thefile);      #OR 3D+: \\nbrick(thefile, lvar =, band = )'
      [7]: 'Yes.'
      [8]: 'Raster Forever?'
      [9]: 'No'
      [10]: 'Yes'
      [11]: 'angstroms + quadmesh'
      [12]: 'DIY?'
      [13]: 'No. (wait for stars)'
      [14]: 'Yes. tidync + tibble, or tidync + arrays'
      [15]: 'Pina Colada'
  
      
      ")
