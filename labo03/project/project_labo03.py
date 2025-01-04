import sys
import os
import glob
import traceback
from nxmap import *

#-------------------------------------------------------
# Variables
#-------------------------------------------------------
top_name      = 'labo03'
fpga_name     = 'NG-MEDIUM'

files         = {'../src/labo03.vhd'
                 }

parameters    = {}

### PADS configuration
pads          = { 'arst_n_i'    : {'location': 'IOB10_D12N'} ,
                  'clk_i'       : {'location': 'IOB12_D09P'} ,
                  'led_n_o[0]'  : {'location': 'IOB0_D01P' } ,
                  'led_n_o[1]'  : {'location': 'IOB0_D03N' } ,
                  'led_n_o[2]'  : {'location': 'IOB0_D03P' } ,
                  'led_n_o[3]'  : {'location': 'IOB1_D05N' } ,
                  'led_n_o[4]'  : {'location': 'IOB1_D05P' } ,
                  'led_n_o[5]'  : {'location': 'IOB1_D06N' } ,
                  'led_n_o[6]'  : {'location': 'IOB1_D06P' } ,
                  'led_n_o[7]'  : {'location': 'IOB1_D02N' } ,
                  'switch_i[0]' : {'location': 'IOB10_D09P'} ,
                  'switch_i[1]' : {'location': 'IOB10_D03P'} ,
                  'switch_i[2]' : {'location': 'IOB10_D03N'} ,
                  'switch_i[3]' : {'location': 'IOB10_D04P'} ,
                  'switch_i[4]' : {'location': 'IOB10_D09N'} ,
                  'switch_i[5]' : {'location': 'IOB10_D04N'} ,
#                 'button_i[0]' : {'location': 'IOB10_D14P'} ,
#                 'button_i[1]' : {'location': 'IOB10_D07P'} ,
#                 'button_i[2]' : {'location': 'IOB10_D12P'} ,
#                 'button_i[3]' : {'location': 'IOB10_D07N'}
                  }
         
###Banks configuration
banks         = { 'IOB10' : { 'voltage': '1.8V'},
                  'IOB12' : { 'voltage': '2.5V'},
                  'IOB0'  : { 'voltage': '3.3V'},
                  'IOB1'  : { 'voltage': '3.3V'}}

###CKGs configuration
ckgs          = { 'wfg_B_clk_i' : 'CKG1:WFG.WFG_C1' }

#-------------------------------------------------------
# Create Project
#-------------------------------------------------------
# Print current working directory
print("[NXMAP3] Create project")
print("[NXMAP3] Current working dir : %s" % os.getcwd())

p = createProject()
p.setVariantName(fpga_name)

#-------------------------------------------------------
# Import Sources
#-------------------------------------------------------
print("[NXMAP3] Import Sources")

for file in files:
    print("[NXMAP3] Add file      : %s" % file)
    p.addFile(file)

print("[NXMAP3] Top Cell      : %s" % top_name)
p.setTopCellName(top_name)

#-------------------------------------------------------
# Top Module Parameters
#-------------------------------------------------------
print("[NXMAP3] Top Module Parameters")

p.addParameters(parameters)

#-------------------------------------------------------
# Pads
#-------------------------------------------------------
print("[NXMAP3] Pads")

p.addPads(pads)
p.addBanks(banks)
p.addRingLocations(ckgs)

p.save('step01_init.nym')

#------------------------------------------------------
# Synthesis
#------------------------------------------------------
print("[NXMAP3] Synthesize")

if not p.synthesize():
    p.destroy()
    sys.exit(1)

p.save('step02_synthesize.nym')

#------------------------------------------------------
# Place
#------------------------------------------------------
print("[NXMAP3] Place")

if not p.place():
    p.destroy()
    sys.exit(1)

p.save('step03_place.nym')

#------------------------------------------------------
# Route
#------------------------------------------------------
print("[NXMAP3] Route")

if not p.route():
    p.destroy()
    sys.exit(1)

p.save('step04_route.nym')

#-------------------------------------------------------
# Report
#-------------------------------------------------------
print("[NXMAP3] Report")
p.reportInstances()

#-------------------------------------------------------
# Bitstream Generation
#-------------------------------------------------------
print("[NXMAP3] Bitstream Generation")
p.generateBitstream(os.path.join(top_name+".nxb"))

#-------------------------------------------------------
# STA
#-------------------------------------------------------
print("[NXMAP3] Timing Analysis")

#Bestcase
Timing_analysis = p.createAnalyzer()
Timing_analysis.launch({'conditions': 'bestcase',  'maximumSlack': 500, 'searchPathsLimit': 10})
#standard
Timing_analysis = p.createAnalyzer()
Timing_analysis.launch({'conditions': 'typical',   'maximumSlack': 500, 'searchPathsLimit': 10})
#Worstcase
Timing_analysis = p.createAnalyzer()
Timing_analysis.launch({'conditions': 'worstcase', 'maximumSlack': 500, 'searchPathsLimit': 10})

#-------------------------------------------------------
# End
#-------------------------------------------------------
p.destroy()
print('[NXMAP3] Errors   : ', getErrorCount())
print('[NXMAP3] Warnings : ', getWarningCount())
