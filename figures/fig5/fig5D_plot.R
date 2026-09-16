library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5D_data.csv"),na.strings="")
points <- subset(d,layer=="point")
p <- ggplot(points,aes(x,y,color=treatment)) +
 geom_hline(yintercept=c(0,100),linetype="dotted",color="grey70",linewidth=.25) +
 geom_line(data=subset(d,layer=="line"),linewidth=.3) +
 geom_errorbar(aes(ymin=ymin,ymax=ymax),width=4,linewidth=.25) +
 geom_errorbar(aes(xmin=xmin,xmax=xmax),orientation="y",width=4,linewidth=.25) +
 geom_point(aes(size=size),shape=21,fill="white",stroke=.39) + scale_size_identity() +
 scale_color_manual(values=c("Sotorasib"="#85A7CD","RMC-7977"="#527BA8","LNP Circuit"="#C87572"),name=NULL) +
 scale_x_continuous(breaks=seq(0,100,25),expand=c(0,0)) +
 scale_y_continuous(breaks=seq(0,100,25),expand=c(0,0)) +
 coord_cartesian(xlim=c(-20,100),ylim=c(-5,112)) +
 labs(x="Relative occupancy (%)",y="Cell viability (% of ctrl.)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),plot.margin=margin(5,12,5,5),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25))
cairo_pdf(output,width=2.6,height=2.1);print(p);invisible(dev.off())
