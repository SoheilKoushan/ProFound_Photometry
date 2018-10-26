#############
# LIBRARIES #
#############
.libPaths(c('/group/pawsey0160/skoushan/R_Library/',.libPaths()))
library('EBImage')
library('celestial')
library('devtools')
#
.libPaths(c('/group/pawsey0160/skoushan/Zeus/Libs/',.libPaths()))
library('Cairo')
library('ProFound') # version 1.2.2
library('magicaxis')
library('data.table')
#
###################
# Setup PATHNAMES #
###################
#
input = '/group/pawsey0160/waves/tiles_sqdeg/LOCATION/'
csv_out = '/group/pawsey0160/waves/csv/LOCATION/'
rds_out = '/group/pawsey0160/waves/rds/LOCATION/'
diag_out = '/group/pawsey0160/waves/diag/LOCATION/'
stack_out = '/group/pawsey0160/waves/stack/LOCATION/'
#
############################
# Run MultiBand Photometry #
############################
#
everything=profoundMultiBand(dir=input,skycut=2, pixcut=7, sigma=2, ext=2,tolerance=1, iters_det=6, iters_tot=2,totappend='t',colappend='c',
                             detectbands=c('r','Z'), multibands=c('u','g','r','i','Z','Y','J','H','K'),
                             magzero=c(0,0,0,0,30,30,30,30,30), dotot=TRUE, docol=TRUE, dogrp=TRUE, boundstats=TRUE, haralickstats=FALSE, verbose=TRUE,
                             boxiters=4,boxadd=c(100,100),roughpedestal=TRUE,redosegim=FALSE,deblend=FALSE,stats=TRUE,groupstats=TRUE,gain=NULL)
#
####################
# Save All Outputs #
####################
#
saveRDS(everything,file=paste0(rds_out,"waves_pro_stack.rds"))
#
#########################
# Write out plots & Cat #
#########################
#
CairoPDF(file=paste0(diag_out,"diagnostics.pdf"),width=24.0,height=24.0)
plot(everything$pro_detect)
dev.off()
#
All <- cbind(everything$pro_detect$segstats, everything$cat_col, everything$cat_tot)
fwrite(All,paste0(csv_out,'MyCat.csv'),na="-999",row.names=FALSE)
#
temp=readFITS(paste0(input,"Z.fits"))
writeFITSim(X=everything$pro_detect$image,header=temp$header,axDat=temp$axDat,file=paste0(stack_out,"stack.fits"))
