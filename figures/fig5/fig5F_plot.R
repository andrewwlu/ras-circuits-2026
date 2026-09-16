library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5F_data.csv"))
p <- ggplot(d,aes(perk,casp3,color=treatment)) +
 geom_errorbar(aes(ymin=ymin,ymax=ymax),width=4,linewidth=.25) +
 geom_errorbar(aes(xmin=xmin,xmax=xmax),orientation="y",width=4,linewidth=.25) +
 geom_point(shape=21,fill="white",size=1,stroke=.3) +
 scale_color_manual(values=c("Neg. Control"="#A8ACB2","Sotorasib"="#85A7CD","RMC-7977"="#527BA8","LNP Circuit"="#C87572"),name=NULL) +
 scale_x_continuous(breaks=seq(0,100,25)) + scale_y_continuous(breaks=seq(0,100,25)) +
 coord_cartesian(xlim=c(0,107),ylim=c(0,100)) +
 labs(x="pERK+ (% of cells)",y="Active Casp3+ (% of cells)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25)) + guides(color=guide_legend(nrow=2))
cairo_pdf(output,width=2.3,height=2.2);print(p);invisible(dev.off())
