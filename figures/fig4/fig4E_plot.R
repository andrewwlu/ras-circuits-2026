library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig4E_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)), "fig4E_data.csv"), na.strings = "")
levels <- c("PBS", "LNP ctrl.", "Apoptosis Circuit", "Pyroptosis Circuit")
d$treatment <- factor(d$treatment, levels = levels)
brackets <- subset(d, layer == "bracket")
p <- ggplot() +
  geom_col(data=subset(d,layer=="bar"),aes(x,y,fill=treatment),width=.7) +
  geom_errorbar(data=subset(d,layer=="bar"),aes(x,ymin=ymin,ymax=ymax),width=.3,linewidth=.25) +
  geom_point(data=subset(d,layer=="point"),aes(x,y),shape=21,fill="white",size=.65,stroke=.25) +
  geom_segment(data=brackets,aes(x=x,xend=xend,y=y,yend=y),linewidth=.25) +
  geom_segment(data=brackets,aes(x=x,xend=x,y=y,yend=y-0.71),linewidth=.25) +
  geom_segment(data=brackets,aes(x=xend,xend=xend,y=y,yend=y-0.71),linewidth=.25) +
  geom_text(data=brackets,aes(x=(x+xend)/2,y=y,label=label),vjust=-.2,size=2.3,family="Arial") +
  scale_fill_manual(values=c("PBS"="#A8ACB2","LNP ctrl."="#8079AC","Apoptosis Circuit"="#648DC0","Pyroptosis Circuit"="#C87572")) +
  scale_x_continuous(breaks=seq_along(levels),labels=c("PBS", "LNP ctrl.", "Apoptosis\ncircuit", "Pyroptosis\ncircuit"),expand=expansion(add=.6)) +
  scale_y_continuous(breaks=c(0,10,20,30),expand=expansion(mult=0)) +
  coord_cartesian(ylim=c(0,35.5),clip="off") +
  labs(x=NULL,y="Liver/body weight (%)") +
  theme_classic(base_size=7,base_family="Arial") +
  theme(legend.position="none",axis.text=element_text(color="black",size=7),
    axis.text.x=element_text(angle=90,hjust=1,vjust=.5),
    axis.line=element_line(linewidth=.25),axis.ticks=element_line(linewidth=.25),
    plot.margin=margin(45,8,5,5))
cairo_pdf(output,width=1.85,height=2.5); print(p); invisible(dev.off())
