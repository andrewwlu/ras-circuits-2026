library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Usage: Rscript fig5A_plot.R output.pdf")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig5A_data.csv"))
d$cell_line <- factor(d$cell_line,c("HEK293","Calu-1","MIA PaCa-2","NCI-H358","SW1573","OV56"))
d$treatment <- factor(d$treatment,c("Sotorasib","RMC-7977","Circuit"))
p <- ggplot(d,aes(treatment,viability,fill=treatment)) +
 geom_hline(yintercept=c(0,100),linetype="dotted",color="grey70",linewidth=.25) +
 geom_col(width=.6) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.25,linewidth=.25) +
 facet_grid(~cell_line) +
 scale_fill_manual(values=c("Sotorasib"="#93B9C9","RMC-7977"="#527BA8","Circuit"="#C87572")) +
 scale_y_continuous(limits=c(-5,115),breaks=seq(0,100,25),expand=c(0,0)) +
 labs(x=NULL,y="Cell viability (% of ctrl.)",fill=NULL) +
 theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text.x=element_blank(),axis.ticks.x=element_blank(),
   axis.text=element_text(color="black"),axis.line=element_line(linewidth=.25),
   axis.ticks=element_line(linewidth=.25),strip.background=element_blank(),
   strip.text=element_text(size=7),legend.position="bottom")
cairo_pdf(output,width=4.6,height=1.8);print(p);invisible(dev.off())
