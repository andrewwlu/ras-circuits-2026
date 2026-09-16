library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig6D_data.csv"))
d$construct <- factor(d$construct,c("NeoR","CCND1 T286A","SHOC2 S2G","YAP1 S127A","MEK1 Q56P"))
plots <- lapply(c("RMC 7977","circuit"),function(tx) {
 z <- subset(d,treatment==tx)
 z$concentration <- factor(z$concentration,levels=sort(unique(z$concentration)))
 ggplot(z,aes(concentration,viability,group=construct,color=construct,shape=construct)) +
 geom_hline(yintercept=100,linetype="dotted",color="grey70",linewidth=.25) +
 geom_line(linewidth=.3) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.12,linewidth=.25) +
 geom_point(fill="white",size=1,stroke=.3) +
 scale_shape_manual(values=c(21,21,25,23,24)) +
 scale_color_manual(values=if(tx=="circuit") c("#CCCCCC","#B44455","#E5B6BE","#CD8190","#8A293D") else c("#CCCCCC","#527BA8","#B4CDDC","#81A7C3","#315B78")) +
 scale_y_continuous(limits=c(0,130),breaks=seq(0,125,25)) +
 labs(title=if(tx=="circuit") "Circuit" else "RMC-7977",x=if(tx=="circuit") "Sensor concentration (pg/µL)" else "RMC-7977 concentration (µM)",y="Cell viability (% of ctrl.)",color=NULL,shape=NULL) +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black"),legend.position="bottom",legend.text=element_text(size=6),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25),plot.title=element_text(hjust=.5)) +
 guides(color=guide_legend(nrow=3),shape=guide_legend(nrow=3))
})
cairo_pdf(output,width=4.8,height=2.4)
grid::grid.newpage();grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2)))
for(i in 1:2) print(plots[[i]],vp=grid::viewport(layout.pos.row=1,layout.pos.col=i),newpage=FALSE)
invisible(dev.off())
