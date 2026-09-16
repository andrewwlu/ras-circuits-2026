library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5E_data.csv"))
p <- ggplot(d,aes(kras,viability_change,color=treatment)) +
 geom_hline(yintercept=0,linetype="dotted",color="grey70",linewidth=.25) +
 geom_line(linewidth=.3) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.08,linewidth=.25) +
 geom_point(shape=21,fill="white",size=1,stroke=.3) +
 scale_color_manual(values=c("Circuit 80 pg/uL"="#C87572","RMC-7977 5 nM"="#527BA8"),name=NULL) +
 scale_x_log10(breaks=c(10,33,100,333),labels=c("10","33","100","333")) +
 scale_y_continuous(breaks=seq(-50,50,25)) + coord_cartesian(xlim=c(5,400),ylim=c(-50,50)) +
 labs(x="KRAS G12V level (ng)",y="Change in cell viability (%)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25))
cairo_pdf(output,width=2.5,height=2.1);print(p);invisible(dev.off())
