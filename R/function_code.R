
#' Load packages for a specific SDS course
#'
#' Given a course name like "sds_291", this will load (and optionally install) the packages needed for that course.
#'
#' @param sds_class A string, like "sds_291","sds_100","sds_220","sds_192"
#' @param install_missing If TRUE, install any packages that aren't currently available
#'
#' @return A named logical vector showing which packages were successfully loaded
#' @export



class_packages <- list(
  sds_291 = c("Stat2Data", "ggplot2", "broom", "dplyr", "equatiomatic", "performance", "see", "gridExtra", "moderndive", "GGally", "infer", "emmeans"),
  sds_100 = c("caret", "randomForest", "glmnet", "skimr"),
  sds_192 = c("BiocManager", "DESeq2", "janitor", "ggpubr"),
  sds_220 = c("tidyverse", "lubridate", "stringr", "readxl")
)
usethis::use_data(class_packages, internal = TRUE, overwrite = TRUE)

load_sds <- function(sds_class, install_missing = TRUE) {

  users_class <- substitute(sds_class)

  if (is.symbol(users_class)) {
    stop(
      "\nClass names must be in quotes.\n",
      "Correct usage: load_sds(\"", as.character(users_class), "\")", "\n",
      "Available classes in this package are: sds_100, sds_192, sds_220, sds_291"
    )
  }

  if (!sds_class %in% names(class_packages)) {
    stop(
      "\nOops! Class not found.\n",
      "Available classes in this package are: sds_100, sds_192, sds_220, sds_291"
    )
  }

  loaded <- setNames(logical(length(sds_class)), sds_class)
  pkgs <- class_packages[[sds_class]]

  for (pkg in pkgs) {
    if (!require(pkg, character.only = TRUE, quietly = TRUE)) {
      if (install_missing) {
        message("Installing package:", pkg)
        tryCatch({
          utils::install.packages(pkg, quiet = TRUE)
          if (require(pkg, character.only = TRUE, quietly = TRUE)) {
            loaded[pkg] <- TRUE
            message("Successfully installed and loaded:", pkg)
          } else {
            warning("Installation succeeded but loading failed for:", pkg)
          }
        }, error = function(e) {
          warning("Failed to install", pkg, ": ", e$message)
        })
      }
    } else {
      loaded[pkg] <- TRUE
      message("Package loaded: ", pkg)
    }
  }
}



