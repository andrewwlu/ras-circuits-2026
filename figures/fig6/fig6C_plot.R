library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig6C_data.csv"))
d$mutation <- factor(d$mutation,c("None","Y96C","H95D","R68S","Y64C","Y71H"))
p <- ggplot(d,aes(mutation,activity,fill=mutation)) +
 geom_col(width=.7) + geom_errorbar(aes(ymin=lower,ymax=upper),width=.4,linewidth=.25) +
 geom_hline(yintercept=100,linetype="dashed",color="grey50",linewidth=.25) +
 scale_fill_manual(values=c("None"="#A8ACB2","Y96C"="#C87572","H95D"="#C87572","R68S"="#C87572","Y64C"="#C87572","Y71H"="#C87572")) +
 scale_y_continuous(limits=c(0,155),breaks=c(0,50,100,150),expand=c(0,0)) +
 labs(x="RAS mutation (+ G12C)",y="Sensor activity (% of KRAS G12C)") +
 theme_classic(base_size=7,base_family="Arial") +
 theme(legend.position="none",axis.text=element_text(color="black"),axis.text.x=element_text(angle=90,hjust=1,vjust=.5),
 axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25))
cairo_pdf(output,width=2.1,height=2);print(p);invisible(dev.off())
