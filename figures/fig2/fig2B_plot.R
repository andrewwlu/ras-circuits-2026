library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig2B_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig2B_data.csv"), na.strings = "")
d$effector <- factor(d$effector,c("Apoptosis","Pyroptosis"))
d$cell_line <- factor(d$cell_line,c("KRAS WT\n(HEK293FT)","KRAS G12C\n(MIA PaCa-2)"))
p <- ggplot(d,aes(factor(effector_concentration),factor(sensor_concentration),fill=viability)) +
  geom_tile(color="white",linewidth=.2) + facet_wrap(vars(effector,cell_line),nrow=1) +
  scale_fill_gradient(low="black",high="white",limits=c(0,115),breaks=c(0,50,100),name="Cell viability\n(% of ctrl.)") +
  scale_x_discrete(breaks=c("0","80","120","160")) + scale_y_discrete(breaks=c("0","80","160")) +
  labs(x="Effector concentration (pg/µL)",y="Sensor concentration (pg/µL)") +
  theme_classic(base_size=7,base_family="Arial") + theme(
  axis.text=element_text(size=6,color="black"),axis.line=element_line(linewidth=.2),
  axis.ticks=element_line(linewidth=.2),strip.background=element_blank(),
  strip.text=element_text(size=7),plot.margin=margin(5,5,5,5)) + theme(aspect.ratio=6/4,axis.line=element_blank(),axis.ticks=element_blank(),
                 legend.key.height=grid::unit(.8,"cm"),legend.title=element_text(size=6),legend.text=element_text(size=6))
cairo_pdf(output,width=5.2,height=2.2);print(p);invisible(dev.off())
