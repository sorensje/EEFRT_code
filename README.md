# EEfRT_code
Jim's code for analyzing Effrt task 

Main analyses are conducted inside .rmd markdown files.

- so far the EEFRT_analysis.rmd is an overall record of all analyses.

### Analysis pipeline:

1. data are collected in MATLAB using modified EEFRT script from MT.

2. data are aggregated into R friendly data files: 
- 'link file writers.m' will use Rfilewriter_EEfRT3.mat to create tab separated .txt files
in data dir of choosing. these files are matrices such that each row represents 1 trial from EEfrt task.
The files contain information on task choice, outcome, and subjective effort for each trial
- 'link RT scrubber.m' will similarly generate .txt files for each participant that describe their performance on the tapping portion of eeffrt

3. data for all subjects are aggregated into .csvs using "aggregate matlab EEfRT LOSS.R"
- location of txt files generated in previous step and target location/name for new csv file must be specified
- WIN and LOSS are currently seperate files, but they perform essentially the same task
- Subject numbers are automatically detected, but there is a line to exclude participants for whom the data files will not work

4. Data are read in prior during analysis
 -  readCleanEffrt.R contains workhorse and helper functions to read in data
  * provides options for checking on incomplete trials and trials in which choices were not made
 - findCheatTrials.R contains a function to find trials in which participants cheated during task. output is df w/ cheat trials added in.
 

### other Data fetching

 "teps\_from\_Qualtrics.R"  retrieves teps from Qualtrics data stored in main PACO folder. 
 - requires: Qualtrics\_Helper\_Functions which can be used to clean and pull selected questionnaires from standard qualtrics output.
 