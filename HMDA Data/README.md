#HMDA Data
This folder contains the script used to clean HMDA data. The script cleans HMDA data from 1990 to 2019 and outputs are stored as .fst files. To load the .fst files use read_fst command in R.
<br/>
More information about the fst package is available here: https://www.fstpackage.org/
<br/>
fst package allows you to reduce memory usage by selecting the required columns without reading the entire data set. To identify the column names read the first few rows using read_fst(path="filename",from=1, to 10). Then pass the selected column names using the following command: read_fst(path="<file name goes here>", columns = c("<selected column 1>","<selected column 2>",...))
<br/>
Files prior to 2004 have limited variables compared to files post 2004.
<br/>
<br/>

The files are organized as follows:<br/>
<ul>
<li>Before 2004</li>
<ol type="i">
  <li>Owner-occupied new purchases (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/EobDEWgLAU9Agj3WXjPC080BzQc7jIDOqeDppjW8uatRWg?e=aW2DLo)</li>
  <li>Owner-occupied refinances(https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/ErNqbCsG7qhEmg5LRhrrOV4BpOdSvbXFTxEpqkLp_mnorg?e=Du0vNo) </li>
  <li>Non owner-occupied new purchases (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/EpuISPAMTh1PiluldluDMnoBUOeMLgEpzH9Vncp6v0xijQ?e=XvPzMO)</li>
  <li>Non owner-occupied refinances (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/EpHZaA0jfFlBhj0vGMEpB5QB5U8ciGP4nCq5GdeL6a9CBA?e=HvUu3G)</li>
</ol>
<li>After 2004</li>
<ol type="i">
  <li>Owner-occupied new purchases (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/Ei9WeG77uzdCoKcFhrZ94vkBqOZopWdVRnoE0hoj6G05Aw?e=LMvK2y)</li>
  <li>Owner-occupied refinances(https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/EpGz8gls5RhLhdpzNAf6faMBhE-zpGd6u0jvQVUmVgBJog?e=iRKgSP) </li>
  <li>Non owner-occupied new purchases (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/En0xG_1GbGBOncYhJVsn_tgB8K8-hHG9-0pl_bwHdO8Psw?e=l5JSme)</li>
  <li>Non owner-occupied refinances (https://lsumail2-my.sharepoint.com/:f:/g/personal/dratnadiwakara2_lsu_edu/EkSWEvjjpHdFgtjsrFRe6GIBuQBAuNiW7JrHXjiH1M2wAw?e=C2C8gh)</li>
</ol>
</ul>