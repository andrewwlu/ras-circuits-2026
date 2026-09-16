library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig1D_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig1D_data.csv"), na.strings = "")
baseline <- d[d$label %in% "Neg. Ctrl.", ]
p <- ggplot(d, aes(wt_ifp,g12c_ifp,color=binder_type)) +
  annotate("polygon",x=c(0,0,415000),y=c(0,415000,415000),fill="#F1F0F5") +
  geom_abline(slope=1,intercept=0,linetype="dashed",color="#999999",linewidth=.2) +
  geom_hline(yintercept=baseline$g12c_ifp,linetype="dotted",color="#999999",linewidth=.2) +
  geom_vline(xintercept=baseline$wt_ifp,linetype="dotted",color="#999999",linewidth=.2) +
  geom_point(size=1.35,stroke=0) +
  annotate("text",x=45000,y=390000,label="Ideal",fontface="italic",hjust=0,size=6/.pt) +
  annotate("text",x=40000,y=20000,label="Neg. Ctrl.",hjust=0,size=6/.pt,color="#999999") +
  annotate("segment",x=d$wt_ifp[d$label %in% "RAF1"],y=d$g12c_ifp[d$label %in% "RAF1"],
           xend=220000,yend=280000,color="#D28F85",linewidth=.2) +
  annotate("text",x=230000,y=280000,label="RAF1:\nsensor v1",hjust=0,size=6/.pt,color="#B86B64") +
  annotate("segment",x=d$wt_ifp[d$label %in% "12VC1"],y=d$g12c_ifp[d$label %in% "12VC1"],
           xend=220000,yend=210000,color="#8079AC",linewidth=.2) +
  annotate("text",x=230000,y=190000,label="12VC1:\nsensor v2",hjust=0,size=6/.pt,color="#8079AC") +
  scale_color_manual(values=c(natural="#D28F85",synthetic="#8079AC",`de novo`="#C8848F",controls="#BEBEBE"),
                     breaks=c("natural","synthetic","de novo"),
                     labels=c("Natural\nproteins","Nanobodies/\nmonobodies/\nsynthetic","De novo\nbinders"),name="Binder type") +
  scale_x_continuous(limits=c(0,415000),breaks=(0:4)*1e5,labels=0:4) +
  scale_y_continuous(limits=c(0,415000),breaks=(0:4)*1e5,labels=0:4) +
  labs(x="Response to overexpressed\nKRAS WT (IFP reporter, ×10⁵ a.u.)",
       y="Response to overexpressed\nKRAS G12C (IFP reporter, ×10⁵ a.u.)") +
  theme_classic(base_size=7, base_family="Arial") +
  theme(axis.text=element_text(size=6,color="black"), axis.line=element_line(linewidth=.2),
        axis.ticks=element_line(linewidth=.2), axis.ticks.length=grid::unit(1.75,"pt"),
        strip.background=element_blank(), strip.text=element_text(size=7),
        plot.margin=margin(5,5,5,5)) + theme(aspect.ratio=1,legend.text=element_text(size=7),legend.title=element_text(face="italic",size=7),
                  legend.key.height=grid::unit(16,"pt"),legend.key.width=grid::unit(6,"pt"))
cairo_pdf(output,width=3.1,height=2.05); print(p); invisible(dev.off())
