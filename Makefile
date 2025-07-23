help: ## Print this help text
	@grep -Eh '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the package
	rm -rf dist
	poetry build

install: build ## Dev install the package locally
	pip install --force-reinstall dist/*.whl

uninstall: ## Dev uninstall the package locally
	pip uninstall -y $(shell poetry version | cut -d ' ' -f 1)

publish: ## Publish the package to PyPI
	rm -rf dist
	poetry publish --build

examples: ## Create example plots
	awk 'BEGIN { for (i = 0; i < 1000; i++) print rand() * 100 }' | vis hist --kde --title 'Vis Histograms' --justsave --output assets/vis_hist --force
	echo -e '1 2\n1.5 3\n2 1\n3 1.5\n2 2' | vis scatter --trend --title 'Vis Scatterplots' --justsave --output assets/vis_scatter --force
	seq 0 0.1 10 | awk '{print $$1, sin($$1)}' | vis line --xlab "Time" --ylab "sin(t)" --title 'Vis Line Plots' --justsave --output assets/vis_line --force
	#
	# Manually run the following in respective desired Kubernetes clusters
	# kubectl get pods --all-namespaces | vis hist --col 5 --sep '   ' --unit day --stat prob --kde --title 'Vis: Kubernetes Pod Ages' --xlab 'Pod age (days)' --justsave --output assets/k8s_hist_a --force
	# kubectl top nodes | vis hist --static --col 2 --bins 10 --step 10 --xmin 0 --xmax 100 --xlab 'CPU util' --kde --title 'Vis: Kubernetes Node CPU Utilization' --justsave --output assets/k8s_hist_b --force
	# kubectl resource-capacity --pods | grep -v '\*.*\*' | vis scatter --static --cols 4 6 --xlab "CPU limits" --ylab "Memory limits" --trend --xmax 40 --ymax 40 --title 'Vis: Kubernetes CPU Limits vs. Memory Limits'--justsave --output assets/k8s_scatter.png --force
