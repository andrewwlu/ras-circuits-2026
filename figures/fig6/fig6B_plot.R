library(ggplot2)
output <- commandArgs(trailingOnly=TRUE)
if(length(output)!=1) stop("Supply the output PDF path.")
dir.create(dirname(output),recursive=TRUE,showWarnings=FALSE)
script <- sub("^--file=","",grep("^--file=",commandArgs(),value=TRUE))
d <- read.csv(file.path(dirname(normalizePath(script)),"fig6B_data.csv"),na.strings="")
arms <- c("Sotorasib","RMC-7977","Circuit")
d$selection <- factor(d$selection,arms); d$challenge <- factor(d$challenge,arms)
cols <- c("Sotorasib"="#85A7CD","RMC-7977"="#527BA8","Circuit"="#C87572")
theme_panel <- theme_classic(base_size=7,base_family="Arial") +
 theme(axis.text=element_text(color="black",size=6),axis.line=element_line(linewidth=.2),axis.ticks=element_line(linewidth=.2),
 legend.position="none",strip.background=element_blank(),strip.text=element_text(size=7))
z <- subset(d,plot=="Dose response" & layer=="point")
w <- subset(d,plot=="Dose response" & layer=="reference");w$selection <- NULL
p <- ggplot() +
 geom_ribbon(data=w,aes(x,ymin=ymin,ymax=ymax,group=challenge),fill="grey80",alpha=.6) +
 geom_line(data=w,aes(x,y,group=challenge),color="grey65",linewidth=.25) +
 geom_line(data=z,aes(x,y,color=selection,group=culture),linewidth=.3) +
 geom_point(data=z,aes(x,y,color=selection),shape=21,fill="white",size=1,stroke=.3) +
 facet_grid(selection~challenge,scales="free_x",switch="y",
 labeller=labeller(challenge=c("Sotorasib"="Sotorasib (µM)","RMC-7977"="RMC-7977 (µM)","Circuit"="Circuit (pg/µL)"))) +
 scale_color_manual(values=cols) +
 scale_x_log10(breaks=c(.0001,.001,.01,.1,1,10,40,80,160,320,640,1280),labels=c("0.0001","0.001","0.01","0.1","1","10","40","80","160","320","640","1280")) +
 scale_y_continuous(limits=c(0,125),breaks=seq(0,125,25)) +
 labs(x="Treatment concentration",y="Cell viability (% of lowest dose)") + theme_panel +
 theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5),strip.placement="outside")
qplots <- lapply(c("Matched potency","Matched residual","Cross potency","Cross residual"),function(key) {
 a <- subset(d,plot==key);pot <- grepl("potency",key);cross <- grepl("Cross",key)
 g <- ggplot() + geom_col(data=subset(a,layer=="bar"),aes(x,y,fill=challenge),width=.68) +
 geom_point(data=subset(a,layer=="point"),aes(x,y),shape=21,fill="white",size=1,stroke=.3) +
 scale_fill_manual(values=cols) +
 scale_x_continuous(breaks=if(cross) 1:2 else 1:3,labels=if(cross) arms[1:2] else arms) +
 labs(x=NULL,y=if(pot) "EC50 fold change" else "Residual viability (%)",
 title=if(cross) "Drug → circuit" else "Matched treatment") + theme_panel +
 theme(axis.text.x=element_text(angle=90,hjust=1,vjust=.5),plot.title=element_text(size=6,hjust=.5))
 if(pot) g+scale_y_continuous(limits=c(-.3,2.3),breaks=0:2,labels=c("1×","10×","100×")) else
 g+scale_y_continuous(limits=c(0,105),breaks=seq(0,100,25))
})
cairo_pdf(output,width=5.4,height=6.1)
grid::grid.newpage();grid::pushViewport(grid::viewport(layout=grid::grid.layout(2,1,heights=c(3.7,2.4))))
print(p,vp=grid::viewport(layout.pos.row=1,layout.pos.col=1),newpage=FALSE)
grid::pushViewport(grid::viewport(layout.pos.row=2,layout.pos.col=1,layout=grid::grid.layout(1,4)))
for(i in 1:4) print(qplots[[i]],vp=grid::viewport(layout.pos.row=1,layout.pos.col=i),newpage=FALSE)
invisible(dev.off())
