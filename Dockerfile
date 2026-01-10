FROM rocker/tidyverse:latest

# 1. Install system dependencies.
# Added 'libmagick++-dev' which is often needed for kableExtra/advanced image processing.
RUN apt-get update && apt-get install -y \
    curl \
    libglpk-dev \
    libgmp3-dev \
    libmpfr-dev \
    coinor-libsymphony-dev \
    coinor-libcgl-dev \
    libmagick++-dev \
    # Install Node.js (v20) for Gemini CLI
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    # Install Gemini CLI globally
    && npm install -g @google/gemini-cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 2. Install R packages.
# Added: qqplotr, kableExtra, gt, DT, flextable
RUN R -e "install.packages(c( \
    'lintr', \
    'styler', \
    'languageserver', \
    'httpgd', \
    'quantmod', \
    'xts', \
    'ichimoku', \
    'PortfolioAnalytics', \
    'CVXR', \
    'ROI', \
    'ROI.plugin.glpk', \
    'ROI.plugin.quadprog', \
    'ROI.plugin.symphony', \
    'PerformanceAnalytics', \
    'fBasics', \
    'car', \
    'leaps', \
    'MASS', \
    'KernSmooth', \
    'forecast', \
    'rugarch', \
    'tinytex', \
    'rmarkdown', \
    'ggpubr', \
    'qqplotr', \
    'kableExtra', \
    'gt', \
    'DT', \
    'flextable' \
    ), dependencies=TRUE)"

# 3. Install TinyTeX (The actual LaTeX backend)
RUN R -e "tinytex::install_tinytex(force = TRUE)"

# 4. Set working directory
WORKDIR /home/rstudio/project

# 5. Copy all files and folders from the host into the container
COPY . .

CMD ["R"]
