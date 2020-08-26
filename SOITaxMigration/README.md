#SOI Tax Stats - Migration Data
This script cleans the county to county migration data from https://www.irs.gov/statistics/soi-tax-stats-migration-data
<br/>
#Output files
The output files have the following variables.<br/>
<ul>
<li>fromstate</li>
<li>fromcounty</li>
<li>tostate</li>
<li>tocounty</li>
<li>statecode</li>
<li>desc</li>
<li>noreturns</li>
<li>noexceptions</li>
<li>agi</li>
<li>file</li>
<li>fromyear</li>
</ul>
<br/>
<br/>
In-migration data file is available [here](https://lsumail2-my.sharepoint.com/:u:/g/personal/dratnadiwakara2_lsu_edu/EV8iK3D0s91MkklTdfHEMv0BHzAAzINafKkmPdO0QHsBIw?e=JhhAt6)<br/>
Out-migration data file is avilable [here](https://lsumail2-my.sharepoint.com/:u:/g/personal/dratnadiwakara2_lsu_edu/ESXIaCosZdVJiP_w5j10GTYBbH4H4ctGT899LtF8HSqWxg?e=8zMucV)
<br/>
<br/>
Files are saved in .fst format. Use read_fst function in R to read the data