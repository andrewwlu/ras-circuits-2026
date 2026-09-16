library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5G_data.csv"))
d$cell_line <- factor(d$cell_line,c("A-431","Caco-2","HepaRG","MCF10A"))
plots <- lapply(c("RMC-7977","Circuit"),function(tx) {
 z <- subset(d,treatment==tx)
 z$concentration <- factor(z$concentration,levels=sort(unique(z$concentration)))
 ggplot(z,aes(concentration,viability,group=cell_line,color=cell_line,shape=cell_line)) +
 geom_hline(yintercept=100,linetype="dotted",color="grey70",linewidth=.25) +
 geom_line(linewidth=.3) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.12,linewidth=.25) +
 geom_point(fill="white",size=1,stroke=.3) +
 scale_shape_manual(values=c(21,25,23,24)) +
 scale_color_manual(values=if(tx=="Circuit") c("#8A293D","#B44455","#CD8190","#E5B6BE") else c("#315B78","#527BA8","#81A7C3","#B4CDDC")) +
 scale_y_continuous(limits=c(0,110),breaks=seq(0,100,25)) +
 labs(title=tx,x=if(tx=="Circuit") "Sensor concentration (pg/µL)" else "RMC-7977 concentration (µM)",y="Cell viability (% of ctrl.)",color=NULL,shape=NULL) +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25),plot.title=element_text(hjust=.5)) +
 guides(color=guide_legend(nrow=2),shape=guide_legend(nrow=2))
})
cairo_pdf(output,width=4.3,height=2.1)
grid::grid.newpage();grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
for(i in 1:2) print(plots[[i]],vp=grid::viewport(layout.pos.row=1,layout.pos.col=i),newpage=FALSE)
invisible(dev.off())
