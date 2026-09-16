# Run with: Rscript fig1B_plot.R /path/to/output/fig1B.pdf
library(ggplot2)
output <- commandArgs(trailingOnly = TRUE)
if (length(output) != 1) stop("Usage: Rscript fig1B_plot.R output.pdf")
dir.create(dirname(output), recursive = TRUE, showWarnings = FALSE)

# Locate the CSV beside this script when invoked from any working directory.
script <- sub("^--file=", "", grep("^--file=", commandArgs(), value = TRUE))
folder <- if (length(script)) dirname(normalizePath(script)) else "."
d <- read.csv(file.path(folder, "fig1B_data.csv"))
d$amplifier_expression <- factor(d$amplifier_expression, c("Low", "Medium", "High"))
d$condition <- factor(d$condition, c("Amplifier only", "Input only", "Input + amplifier"))
d <- d[order(d$condition), ]
colors <- c("Input only" = "#8079AC", "Amplifier only" = "#A8ACB2",
            "Input + amplifier" = "#C8848F")
labels <- data.frame(amplifier_expression = factor("High", levels(d$amplifier_expression)),
                     condition = names(colors), y = c(235000, 65000, 730000),
                     label = c("Input\nonly", "Amplifier\nonly", "Input +\namplifier"))

p <- ggplot(d, aes(bfp, ifp, color = condition, group = condition)) +
  geom_line(linewidth = 0.225) +
  geom_errorbar(aes(ymin = ifp_lower, ymax = ifp_upper), width = 0.3, linewidth = 0.225) +
  geom_point(aes(shape = condition), fill = "white", size = 1, stroke = 0.39) +
  facet_wrap(~amplifier_expression, nrow = 1,
             labeller = as_labeller(c(Low = "Low amplifier\nexpression",
                                     Medium = "Medium amplifier\nexpression",
                                     High = "High amplifier\nexpression"))) +
  geom_text(data = labels, aes(x = 9e5, y = y, label = label, color = condition),
            inherit.aes = FALSE, hjust = 0, lineheight = 0.9, size = 6 / .pt) +
  scale_color_manual(values = colors) +
  scale_shape_manual(values = c("Input only" = 21, "Amplifier only" = 23,
                                "Input + amplifier" = 24)) +
  scale_x_log10(breaks = 10^(2:5), labels = scales::label_log(),
                limits = c(100, 9e5), expand = expansion(mult = c(0.03, 0.02))) +
  scale_y_continuous(breaks = c(0, 2e5, 4e5, 6e5), labels = c("0", "2", "4", "6"),
                     limits = c(0, 8e5), expand = expansion(mult = c(0.03, 0))) +
  coord_cartesian(clip = "off") +
  labs(x = "Input protease expression (BFP fluorescence, a.u.)",
       y = "TEV + TVMV protease\nactivity (IFP reporter, a.u.)") +
  theme_classic(base_size = 7, base_family = "Arial") +
  theme(legend.position = "none", strip.background = element_blank(),
        strip.text = element_text(size = 7, margin = margin(b = 5)),
        axis.text = element_text(size = 6, color = "#1E1E1E"),
        axis.title = element_text(size = 7),
        axis.line = element_line(linewidth = 0.2, color = "#666666"),
        axis.ticks = element_line(linewidth = 0.2, color = "#666666"),
        axis.ticks.length = grid::unit(1.75, "pt"),
        panel.spacing.x = grid::unit(7, "pt"),
        plot.margin = margin(3, 32, 3, 3))

# Shared y-axis multiplier.
cairo_pdf(output, width = 3.95, height = 1.65)
g <- ggplotGrob(p)
panel <- g$layout[g$layout$name == "panel-1-1", ]
g <- gtable::gtable_add_grob(g, grid::textGrob(expression("x" * 10^5),
                            x = grid::unit(-7, "pt"), y = grid::unit(1, "npc"),
                            just = c("left", "bottom"),
                            gp = grid::gpar(fontfamily = "Arial", fontsize = 7)),
                           t = panel$t, l = panel$l, clip = "off")
grid::grid.draw(g)
invisible(dev.off())
