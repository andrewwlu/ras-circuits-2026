library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig1G_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig1G_data.csv"), na.strings = "")
d$binder <- factor(d$binder,c("dead 12VC1","12VC1","12D4"))
p <- ggplot(d,aes(ruby,ifp,color=ras)) +
  geom_line(linewidth=.225) + geom_errorbar(aes(ymin=ifp_lower,ymax=ifp_upper),width=.2,linewidth=.225) +
  geom_point(shape=21,fill="white",size=1,stroke=.3) + facet_wrap(~binder,nrow=1) +
  scale_color_manual(values=c(`KRAS WT`="#A8ACB2",`KRAS G12C`="#8079AC",`KRAS G12D`="#C8848F")) +
  scale_x_log10(breaks=10^(3:5),labels=scales::label_log()) +
  scale_y_continuous(breaks=(0:3)*1e5,labels=0:3) +
  labs(x="Ras expression (Ruby fluorescence, a.u.)",y="Sensor activation\n(IFP reporter, ×10⁵ a.u.)",color=NULL) +
  theme_classic(base_size=7, base_family="Arial") +
  theme(axis.text=element_text(size=6,color="black"), axis.line=element_line(linewidth=.2),
        axis.ticks=element_line(linewidth=.2), axis.ticks.length=grid::unit(1.75,"pt"),
        strip.background=element_blank(), strip.text=element_text(size=7),
        plot.margin=margin(5,5,5,5)) + theme(legend.position="right",legend.text=element_text(size=6))
cairo_pdf(output,width=4.5,height=1.65); print(p); invisible(dev.off())
