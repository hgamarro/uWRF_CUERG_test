#!/home/hgamarro/anaconda2/bin/python
#############################################################################
# A script to extract and merge variables from WRF output files for ease    #
# of analysis.                                                              #
# TODO:  Switch from os.system() to subprocess.call() since os.system will  #
#        soon be deprecated and is less useful.                             #
#############################################################################


import os
from subprocess import Popen, PIPE
import tqdm

############################################################################
# Input parameters used. ONLY CHANGE THESE PARAMETERS
############################################################################
source = 'wrf_solar_cuerg.'  # Used for building output file name. Use as file label
domain = [3]     # Domain of interest to be extracted.
varname = ['SWDDNI', 'SWDDIR', 'SWDDIF', 'U10', 'V10', 'T2', 'COSZEN'] # WRF variable to extract. More than one can be specified

############################################################################

def merge(varname, domain, source, preamble='wrfout_d0'):
    
    # Input parameters used.
    indir = './'   # directory where input data is located.
    outdir = './'  # directory where output file will be located (up to user)
    preambleIndex = len(preamble) + 1

    # Get a list of all the 
    dirlist = os.listdir(outdir)
    wrffiles = [f for f in dirlist if f[:preambleIndex] == preamble + str(domain)]
    
    # First we grab the variable varname from each file and create a temporary
    # file for each. 
    
    for n in tqdm.tqdm(range(len(wrffiles))):
            os.system('cdo -s selname,' + varname + ' '+ wrffiles[n] + ' temp.' +
                      wrffiles[n][11:15] + wrffiles[n][16:18] + wrffiles[n][19:21] + 
                      wrffiles[n][22:24] + wrffiles[n][25:27])
            
    # Merge all time steps into a single file and remove all temporary files.
    os.system('cdo cat temp.*' + ' ' + varname.lower() + '.' + source + 
              'd0' + str(domain) + '.nc')
    os.system('rm temp.*')
    print ##############################
    print # MERGE.PY COMPLETED!        #
    print ##############################

for m, var in enumerate(varname):
    for n, dom in enumerate(domain):
        print var, dom
        merge(var, dom, source)
