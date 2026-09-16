library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig6E_data.csv"),na.strings="")
p <- ggplot(subset(d,layer=="point"),aes(day,volume,color=treatment)) +
 geom_line(linewidth=.3) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.2,linewidth=.25) +
 geom_point(shape=21,fill="white",size=1,stroke=.3) +
 geom_segment(data=subset(d,layer=="bracket"),aes(x=day,xend=day,y=lower,yend=volume),inherit.aes=FALSE,linewidth=.25) +
 geom_segment(data=subset(d,layer=="bracket"),aes(x=day-.2,xend=day,y=lower,yend=lower),inherit.aes=FALSE,linewidth=.25) +
 geom_segment(data=subset(d,layer=="bracket"),aes(x=day-.2,xend=day,y=volume,yend=volume),inherit.aes=FALSE,linewidth=.25) +
 geom_text(data=subset(d,layer=="bracket"),aes(x=day+.25,y=(volume+lower)/2,label=label),inherit.aes=FALSE,angle=90,size=2.3) +
 scale_color_manual(values=c("PBS"="#A8ACB2","Circuits-control"="#555555","RMC-7977"="#527BA8","Circuits-pyroptosis"="#C87572"),name=NULL) +
 scale_x_continuous(breaks=c(16,19,22,25)) +
 labs(x="Day after engraftment",y="Mean volume ± SEM (mm³)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25)) + guides(color=guide_legend(nrow=2))
cairo_pdf(output,width=2.6,height=2.3);print(p);invisible(dev.off())
