library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig1F_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig1F_data.csv"), na.strings = "")
d$ras_status <- factor(d$ras_status,c("WT RAS","Mutant RAS"))
ct <- c("HEK293 Rasless","PLC/PRF/5","SNU-423","SNU-449","SNU-475","MIA PaCa-2","NCI-H358","NCI-H441")
cols <- setNames(c("#D1D1D1","#BEBEBE","#ABABAB","#989898","#858585","#8079AC","#A49ECC","#BAB6D8"),ct)
shapes <- setNames(c(22,21,24,23,25,21,24,23),ct)
p <- ggplot(d,aes(bfp,ifp,color=cell_line,shape=cell_line)) +
  geom_line(linewidth=.225) + geom_errorbar(aes(ymin=ifp_lower,ymax=ifp_upper),width=.2,linewidth=.225) +
  geom_point(fill="white",size=1,stroke=.3) + facet_wrap(~ras_status,nrow=1) +
  scale_color_manual(values=cols,breaks=ct) + scale_shape_manual(values=shapes,breaks=ct) +
  scale_x_log10(breaks=10^(3:6),labels=scales::label_log()) +
  scale_y_continuous(breaks=(0:3)*1e5,labels=0:3) +
  coord_cartesian(xlim=c(1e3,10^5.75),ylim=c(0,3.5e5)) +
  labs(x="Sensor expression (BFP, a.u.)",y="Sensor activation\n(IFP reporter, ×10⁵ a.u.)",color=NULL,shape=NULL) +
  theme_classic(base_size=7, base_family="Arial") +
  theme(axis.text=element_text(size=6,color="black"), axis.line=element_line(linewidth=.2),
        axis.ticks=element_line(linewidth=.2), axis.ticks.length=grid::unit(1.75,"pt"),
        strip.background=element_blank(), strip.text=element_text(size=7),
        plot.margin=margin(5,5,5,5)) + theme(legend.position="bottom",legend.text=element_text(size=6),legend.key.height=grid::unit(8,"pt")) +
  guides(color=guide_legend(ncol=3),shape=guide_legend(ncol=3))
cairo_pdf(output,width=3.4,height=2.1); print(p); invisible(dev.off())
