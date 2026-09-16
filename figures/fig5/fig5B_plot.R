library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5B_data.csv"))
p <- ggplot(d,aes(days,viability,color=treatment)) +
 annotate("rect",xmin=-Inf,xmax=Inf,ymin=100,ymax=Inf,fill="#F4F8FB") +
 annotate("rect",xmin=-Inf,xmax=Inf,ymin=-Inf,ymax=100,fill="#FBF6F4") +
 geom_hline(yintercept=100,linetype="dotted",color="grey60",linewidth=.25) +
 geom_line(linewidth=.3) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.12,linewidth=.25) +
 geom_point(shape=21,fill="white",size=1,stroke=.3) + facet_grid(~cell_line) +
 scale_color_manual(values=c("DMSO"="#A8ACB2","Sotorasib"="#85A7CD","RMC-7977"="#527BA8","Circuit"="#C87572"),name=NULL) +
 scale_x_continuous(breaks=0:5) + scale_y_continuous(breaks=c(0,200,400,600)) +
 coord_cartesian(xlim=c(-.25,5),ylim=c(-50,620)) +
 labs(x="Days since treatment",y="Cell viability\n(% of control at day 0)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),strip.background=element_blank(),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25))
cairo_pdf(output,width=3.6,height=2);print(p);invisible(dev.off())
