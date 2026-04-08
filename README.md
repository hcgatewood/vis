# Vis

`vis` is a CLI for visualizing fuzzy tabular data without leaving the terminal.

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/logo.png" alt="vis logo" width="300"/></p>

## Features

`vis` provides quick, on-the-fly visualizations of tabular data that may not be perfectly structured. Whether it's output from a command, log file, messy CSV, or more, vis can parse and visualize it with a short one-liner.

- **Visualize** 1D data as histograms and 2D data as scatter/line plots, via [Matplotlib](https://matplotlib.org)-based visualizations managed by [Seaborn](https://seaborn.pydata.org)
- **Fuzzy parsing** extracts numbers from messy data, no strict columns or formats required
- **Units and time parsing** convert human-friendly formats like `5GB`, `2h30m`, or `3 days ago` into numbers for plotting
- **Boundary control** with options to filter outliers or set axis limits
- **Trend lines and KDE** for deeper insights into data distributions and relationships
- **Clean-only mode** to just extract and print the parsed numbers without plotting, perfect for data cleaning

## Install

```bash
pip install vis_cli
```

## Examples

### Histograms

```shell
awk 'BEGIN { for (i = 0; i < 1000; i++) print rand() * 100 }' | vis hist --kde
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/vis_hist.png" alt="vis histograms" width="550"/></p>

### Scatter plots

```shell
echo -e 'messy 1 data2\nstill1.5results3\n2 1 in\n3    1.5\n2clean2  outputs' | vis scatter --trend
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/vis_scatter.png" alt="vis scatter plots" width="550"/></p>

### Line plots

```shell
seq 0 0.1 10 | awk '{print $1, sin($1)}' | vis line --xlab "Time" --ylab "sin(t)"
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/vis_line.png" alt="vis line plots" width="550"/></p>

### Histogram: Kubernetes pod ages

```shell
kubectl get pods --all-namespaces | vis hist --col 5 --sep '   ' --unit day --kde --xlab 'Pod age (days)'
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/k8s_hist_a.png" alt="vis histogram Kubernetes pod age" width="550"/></p>

### Histogram: Kubernetes CPU utilization

```shell
kubectl top nodes | vis hist --static --col 2 --bins 10 --xmax 100 --xlab 'CPU util' --kde
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/k8s_hist_b.png" alt="vis histogram Kubernetes CPU utilization" width="550"/></p>

### Scatter plot: Kubernetes pod CPU vs memory limits

```shell
kubectl resource-capacity --pods | grep -v '\*.*\*' | vis scatter --static --cols 4 6 --xlab "CPU limits" --ylab "Memory limits" --trend
```

<p align="center"><img src="https://raw.githubusercontent.com/hcgatewood/vis/main/assets/k8s_scatter.png" alt="vis scatter plot Kubernetes pod CPU vs memory limits" width="550"/></p>

## Usage

```text
$ vis --help
Usage: vis [OPTIONS] COMMAND [ARGS]...

  A fuzzy tabular data visualization tool.

Options:
  -h, --help  Show this message and exit.

Commands:
  clean    Clean the data from a file or stdin and print it to stdout.
  hist     Create a histogram from numerical data.
  line     Create a line plot from tabular data.
  scatter  Create a scatter plot from tabular data.
```

## How I use vis

I mainly use `vis` to investigate issues in Kubernetes clusters.

### Check for large replica counts

```shell
kubectl get pinapps | vis hist --col 2 --sep '   '
```

### Check for lagging jobs

```shell
kubectl get pinterestjobset | vis hist --time --col 1 --sep '   ' --xmax '1 week ago'
```

## See also

- 🪄 [Kuba](https://github.com/hcgatewood/kuba): the magical kubectl companion
- 🐙 [Jdd](https://github.com/hcgatewood/jdd): JSON diff diver, the time machine for your JSON
- ⚡️ [Dotsync](https://github.com/hcgatewood/dotsync): dotfiles everywhere, instantly
- ☁️ [Appa](https://github.com/hcgatewood/appa): Markdown previews with live reload
- 🔮 [PDate](https://github.com/hcgatewood/pdate): human-readable dates and times
