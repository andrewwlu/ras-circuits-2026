library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig2A_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig2A_data.csv"), na.strings = "")
ct <- c("SNU398","SNU475","HEK293","MIA PaCa-2","NCI-H358","SW1573","OV56")
d$ras_status <- factor(d$ras_status,c("KRAS WT\n(off-target)","KRAS G12C\n(on-target)"))
cols <- setNames(c("#D1D1D1","#ABABAB","#858585","#C85C52","#D7796F","#E3978D","#EDB5AF"),ct)
shapes <- setNames(c(22,21,24,21,24,23,25),ct)
p <- ggplot(d,aes(sensor_concentration,viability,color=cell_line,shape=cell_line)) +
  geom_hline(yintercept=100,color="#999999",linetype="dotted",linewidth=.2) +
  geom_line(linewidth=.25) + geom_errorbar(aes(ymin=lower,ymax=upper),width=16,linewidth=.25) +
  geom_point(fill="white",size=1.1,stroke=.3) + facet_wrap(~ras_status,nrow=1) +
  scale_color_manual(values=cols,breaks=ct) + scale_shape_manual(values=shapes,breaks=ct) +
  scale_x_continuous(breaks=seq(0,200,50)) + scale_y_continuous(breaks=seq(0,100,25)) +
  coord_cartesian(ylim=c(0,120)) + labs(x="Sensor concentration (pg/µL)",y="Cell viability (% of ctrl.)",color=NULL,shape=NULL) +
  theme_classic(base_size=7,base_family="Arial") + theme(
  axis.text=element_text(size=6,color="black"),axis.line=element_line(linewidth=.2),
  axis.ticks=element_line(linewidth=.2),strip.background=element_blank(),
  strip.text=element_text(size=7),plot.margin=margin(5,5,5,5)) + theme(legend.position="bottom",legend.text=element_text(size=6),legend.key.height=grid::unit(8,"pt")) +
  guides(color=guide_legend(ncol=4),shape=guide_legend(ncol=4))
cairo_pdf(output,width=3.7,height=2.05);print(p);invisible(dev.off())
