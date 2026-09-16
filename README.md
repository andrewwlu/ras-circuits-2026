# Figure data and plotting scripts

Data and R scripts are organized by figure in `figures/fig1/`, `figures/fig2/`, and so on. Each included panel has a matching `_data.csv` and `_plot.R` file. Multiple facets belonging to the same panel are included together. Scripts save a PDF to the output path supplied when running them.

## Requirements

R with **ggplot2** and its dependencies (`scales`, `gtable`, and the R `grid` package). Install ggplot2 with:

```r
install.packages("ggplot2")
```

The scripts use Arial and the Cairo PDF graphics device. Arial should be available on the machine used to render the figures; font substitution can affect layout. Tested with R 4.5.2 and ggplot2 4.0.2.

## Run a panel

From this directory:

```sh
Rscript figures/fig1/fig1B_plot.R /path/to/output/fig1B.pdf
```

Replace `/path/to/output/fig1B.pdf` with your desired output location. The script locates its CSV beside itself and can be invoked by its full path from any working directory.

## Included panels

Each row below links to a panel's data and plotting script. All facets of a panel are rendered together.

| Panel | Data | Script | Content |
| --- | --- | --- | --- |
| Fig. 1B | [CSV](figures/fig1/fig1B_data.csv) | [R](figures/fig1/fig1B_plot.R) | Amplifier response curves |
| Fig. 1D | [CSV](figures/fig1/fig1D_data.csv) | [R](figures/fig1/fig1D_plot.R) | Sensor screen |
| Fig. 1E | [CSV](figures/fig1/fig1E_data.csv) | [R](figures/fig1/fig1E_plot.R) | KRAS variant responses |
| Fig. 1F | [CSV](figures/fig1/fig1F_data.csv) | [R](figures/fig1/fig1F_plot.R) | Responses across cell lines |
| Fig. 1G | [CSV](figures/fig1/fig1G_data.csv) | [R](figures/fig1/fig1G_plot.R) | Binder and KRAS variant responses |
| Fig. 2A | [CSV](figures/fig2/fig2A_data.csv) | [R](figures/fig2/fig2A_plot.R) | Cell viability dose responses |
| Fig. 2B | [CSV](figures/fig2/fig2B_data.csv) | [R](figures/fig2/fig2B_plot.R) | Sensor–effector viability matrices |
| Fig. 4E | [CSV](figures/fig4/fig4E_data.csv) | [R](figures/fig4/fig4E_plot.R) | Liver/body weight, experiment 2 |
| Fig. 4G | [CSV](figures/fig4/fig4G_data.csv) | [R](figures/fig4/fig4G_plot.R) | Liver/body weight, experiment 3 |
| Fig. 5A | [CSV](figures/fig5/fig5A_data.csv) | [R](figures/fig5/fig5A_plot.R) | Cell-line viability comparison |
| Fig. 5B | [CSV](figures/fig5/fig5B_data.csv) | [R](figures/fig5/fig5B_plot.R) | Viability timecourses |
| Fig. 5D | [CSV](figures/fig5/fig5D_data.csv) | [R](figures/fig5/fig5D_plot.R) | Relative occupancy and viability |
| Fig. 5E | [CSV](figures/fig5/fig5E_data.csv) | [R](figures/fig5/fig5E_plot.R) | Viability change across KRAS levels |
| Fig. 5F | [CSV](figures/fig5/fig5F_data.csv) | [R](figures/fig5/fig5F_plot.R) | pERK and active caspase-3 |
| Fig. 5G | [CSV](figures/fig5/fig5G_data.csv) | [R](figures/fig5/fig5G_plot.R) | Wild-type cell viability |
| Fig. 5H | [CSV](figures/fig5/fig5H_data.csv) | [R](figures/fig5/fig5H_plot.R) | Differential gene expression |
| Fig. 6B | [CSV](figures/fig6/fig6B_data.csv) | [R](figures/fig6/fig6B_plot.R) | Acquired resistance and quantification |
| Fig. 6C | [CSV](figures/fig6/fig6C_data.csv) | [R](figures/fig6/fig6C_plot.R) | Drug-resistant RAS variants |
| Fig. 6D | [CSV](figures/fig6/fig6D_data.csv) | [R](figures/fig6/fig6D_plot.R) | Compensatory signaling |
| Fig. 6E | [CSV](figures/fig6/fig6E_data.csv) | [R](figures/fig6/fig6E_plot.R) | Xenograft tumor volume |

## Data conventions

Fluorescence is reported in arbitrary units; viability and liver/body weight are percentages. Concentration units are shown on the corresponding axes. Lower and upper columns contain the displayed error-bar bounds. These represent 95% bootstrap confidence intervals for Fig. 1B/E/F/G; SD for Fig. 2A and Fig. 5A/B/F; and SEM for Fig. 4E/G, Fig. 5D/E/G and Fig. 6C/D/E. Fig. 6B's control ribbon spans the control-culture minimum and maximum.

Some CSVs contain a `layer` column to distinguish observations, summaries, reference lines, fitted lines, or annotations. Blank cells indicate fields that do not apply to that layer. Fig. 1E includes a WT reference row; its interval fields are blank because the reference is drawn as a line. Fig. 5H combines bar counts and volcano points; `x` is the signed gene count for bars and log₂ fold change for volcano points, and `y` is capped −log₁₀ FDR for volcano points. In Fig. 6B, `plot` identifies the dose-response and quantification plots; potency values are log₁₀ EC₅₀ fold changes, with fold-change tick labels.
