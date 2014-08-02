MonkeyLab
=========

The MonkeyLab repository contains a list of function for analyzing raw electrode waveforms. The functions are custom made for use in Erik Cook's lab. The functions perform tasks such as filtering raw electrode wavefomrs, computing Multi Units, storing large amounts of data efficiently, computing spike triggered averages, computing an average neural response to a specified stimuli. The function "MultiUnitJointMetrics" makes use of the matlab "parfor" functionality that executes loops in parallel on multiple processors. 

The functions "RootMeanSquare.m" and "CoherenceTriggeredAverage.m" also generate postscript files that contain plots. The plots are appended to their respective files as they are generated.

These functions are supposed to be compatible with data collecting systems in the Cook lab and are meant as a helpful guide for future students in the lab.
  
    
-- Haider Riaz Khan
