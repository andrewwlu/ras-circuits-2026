library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig1E_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig1E_data.csv"), na.strings = "")
wt <- d[d$mutation=="WT", ]
bars <- d[d$mutation!="WT", ]
bars$mutation <- factor(bars$mutation,levels=bars$mutation)
p <- ggplot(bars,aes(mutation,ifp)) +
  geom_col(fill="#8079AC",width=.65) +
  geom_errorbar(aes(ymin=ifp_lower,ymax=ifp_upper),width=.4,linewidth=.225) +
  geom_hline(yintercept=wt$ifp,linetype="dotted",color="#999999",linewidth=.2) +
  annotate("text",x=15.6,y=wt$ifp,label="WT KRAS",hjust=0,vjust=-.3,size=2,color="#999999") +
  coord_cartesian(clip="off") +
  scale_y_continuous(breaks=(0:5)*1e5,labels=0:5,expand=expansion(mult=c(0,.04))) +
  labs(x="Overexpressed KRAS mutant",y="Sensor activation\n(IFP reporter, ×10⁵ a.u.)") +
  theme_classic(base_size=7, base_family="Arial") +
  theme(axis.text=element_text(size=6,color="black"), axis.line=element_line(linewidth=.2),
        axis.ticks=element_line(linewidth=.2), axis.ticks.length=grid::unit(1.75,"pt"),
        strip.background=element_blank(), strip.text=element_text(size=7),
        plot.margin=margin(5,32,5,5)) + theme(axis.text.x=element_text(angle=90,vjust=.5,hjust=1),legend.position="none")
cairo_pdf(output,width=2.8,height=1.8); print(p); invisible(dev.off())
