library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5H_data.csv"),na.strings="")
b <- subset(d,layer=="bar")
b$comparison <- factor(b$comparison,rev(c("Sotorasib 1 µM","RMC 30 nM","LNP negative control","LNP positive control","Sensor high","Sensor high + Casp3")))
pbar <- ggplot(b,aes(x,comparison,fill=color)) +
 geom_col(width=.7) + geom_vline(xintercept=0,linewidth=.25) +
 geom_text(aes(x=ifelse(abs(x)<300,ifelse(x<0,-300,300),x),label=format(abs(x),big.mark=",",trim=TRUE),hjust=ifelse(x<0,1.05,-.05)),size=2.3,family="Arial") +
 scale_fill_manual(values=c("Sotorasib"="#85A7CD","RMC-7977"="#527BA8","Negative control"="#A8ACB2","Positive control"="#555555","Circuit"="#C87572")) +
 scale_x_continuous(breaks=seq(-4000,2000,2000),labels=abs,limits=c(-5500,3000)) +
 scale_y_discrete(labels=c("Sotorasib 1 µM"="Sotorasib vs DMSO","RMC 30 nM"="RMC-7977 vs DMSO","LNP negative control"="NeoR vs DMSO","LNP positive control"="Cell death vs NeoR","Sensor high"="Sensor vs NeoR","Sensor high + Casp3"="Circuit vs NeoR")) +
 labs(x="Differentially expressed genes (#)",y=NULL,title="Downregulated       Upregulated") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(legend.position="none",axis.line.y=element_blank(),axis.ticks.y=element_blank(),
 axis.text=element_text(color="black"),plot.title=element_text(size=7,hjust=.5))
v <- subset(d,layer=="point")
v$comparison <- factor(v$comparison,c("RMC-7977 30 nM","Sensor High","Sensor High + Casp3"))
pvol <- ggplot(v,aes(x,y)) +
 geom_hline(yintercept=1.301029995663981,linetype="dashed",color="grey60",linewidth=.2) +
 geom_vline(xintercept=c(-1,1),linetype="dashed",color="grey60",linewidth=.2) +
 geom_point(aes(color=color),size=.5,alpha=.6,stroke=0) +
 geom_point(data=subset(v,!is.na(label)),shape=21,fill=NA,size=1,stroke=.5) +
 geom_text(data=subset(v,!is.na(label)),aes(label=label),hjust=1,nudge_x=-.6,size=2.1,family="Arial") +
 facet_grid(~comparison,labeller=labeller(comparison=c("RMC-7977 30 nM"="RMC vs DMSO","Sensor High"="Sensor vs NeoR","Sensor High + Casp3"="Circuit vs NeoR"))) +
 scale_color_manual(values=c("Not significant"="#C9C9C9","FDR only"="#767676","DE (RMC)"="#6F665D","DE (circuit)"="#D48478")) +
 scale_x_continuous(breaks=seq(-10,10,5)) + scale_y_continuous(breaks=seq(0,40,10),expand=expansion(mult=c(0,.045))) +
 coord_cartesian(xlim=c(-11,11),ylim=c(0,40),clip="off") +
 labs(x=expression(log[2]("fold change vs. reference")),y=expression(-log[10]("false discovery rate"))) +
 theme_classic(base_size=7,base_family="Arial") +
 theme(legend.position="none",strip.background=element_blank(),strip.text=element_text(size=6),
 axis.text=element_text(color="black"),axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25))
cairo_pdf(output,width=7,height=2.3)
grid::grid.newpage();grid::pushViewport(grid::viewport(layout=grid::grid.layout(1,2,widths=c(2.6,4.4))))
print(pbar,vp=grid::viewport(layout.pos.row=1,layout.pos.col=1),newpage=FALSE)
print(pvol,vp=grid::viewport(layout.pos.row=1,layout.pos.col=2),newpage=FALSE)
invisible(dev.off())
