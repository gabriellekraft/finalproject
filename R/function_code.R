
sds <- function(sds_packages, install_missing = TRUE, quiet = FALSE) {
  loaded <- setNames(logical(length(sds_packages)), sds_packages)

  for (pkg in sds_packages) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      if (install_missing) {
        if (!quiet) message("Installing package:", pkg)
        tryCatch({
          utils::install.packages(pkg, quiet = TRUE)
          if (require(pkg, character.only = TRUE, quietly = TRUE)) {
            loaded[pkg] <- TRUE
            if (!quiet) message("Successfully installed and loaded:", pkg)
          } else {
            if (!quiet) warning("Installation succeeded but loading failed for:", pkg)
          }
        }, error = function(e) {
          if (!quiet) warning("Failed to install", pkg, ": ", e$message)
        })
      }
    } else {
      loaded[pkg] <- TRUE
      if (!quiet) message("Package loaded: ", pkg)
    }
  }

}


