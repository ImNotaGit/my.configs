Sys.setenv(LOCALE="en_US.UTF-8")

options(
  warn=1,
  bitmapType = "cairo",
  clustermq.scheduler = "sge",
  clustermq.template = "~/.clustermq.sge.tmpl",
  clustermq.worker.timeout = 60*60*24,
  width=200
)

local({
  r.ver <- with(R.version, paste0(major, ".", substr(minor, 1, 1)))
  bioc.ver <- switch(r.ver, `4.0`="3.12", `4.1`="3.14", `4.2`="3.16", `4.3`="3.18", `4.4`="3.19")
  repos <- sprintf(c(
    "https://packagemanager.posit.co/cran/latest",
    "https://bioconductor.org/packages/%s/bioc",
    "https://bioconductor.org/packages/%s/data/annotation",
    "https://bioconductor.org/packages/%s/data/experiment",
    "https://bioconductor.org/packages/%s/workflows",
    "https://bioconductor.org/packages/%s/books"
  ), bioc.ver)
  names(repos) <- c("CRAN", "BioCsoft", "BioCann", "BioCexp", "BioCworkflows", "BioCbooks")
  options(repos=repos)
})

if (interactive()) {
  suppressPackageStartupMessages({
    library(my.utils)
  })
}
