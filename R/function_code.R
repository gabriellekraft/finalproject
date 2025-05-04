

# sofija: we need to update these to actually represent the classes
# this list is saved in our sysdata file

# misc notes: please do a unit test and also see if it works with the git:install thing
# this code is hella commented it took for EVER
# ive tested a number of different inputs but lmk if its working for you too

class_packages <- list(
  sds_291 = c("Stat2Data", "ggplot2", "broom", "dplyr", "equatiomatic", "performance", "see", "gridExtra", "moderndive", "GGally", "infer", "emmeans"),
  sds_100 = c("caret", "randomForest", "glmnet"),
  sds_192 = c("BiocManager", "DESeq2"),
  sds_220 = c("tidyverse")
)

usethis::use_data(class_packages, internal = TRUE, overwrite = TRUE)

load_sds <- function(sds_class, install_missing = TRUE) {
  # install_missing is just whether the user wants to install missing packages or not!
  # I have it in here just in case


  # substitution is in the AR Chp. 19.3.4!!
  # the issue I ran into is that R would throw an error for a non-existent object before messaging about it
  # substitute means that R doesn't try to find a value for the input and instead works with it as an unevaluated expression
  users_class <- substitute(sds_class)

  # another massive thing i hit was how R was dealing with quotes
  # is.symbol asks R if the users_class is quoted
  # if true (unquoted), then it launches a message telling the user to go quote it
  if (is.symbol(users_class)) {
    stop(
      "\nClass names must be in quotes.\n",
      "Correct usage: load_sds(\"", as.character(users_class), "\")", "\n",
      "Available classes in this package are: sds_100, sds_192, sds_220, sds_291"
    )
  }

  # another hurdle here. I was struggling to get non-included packages kicked out before the for loop
  # this basically says: if the input isn't in the list of class vectors (stored in sysdata), then messsage user
  if (!sds_class %in% names(class_packages)) {
    stop(
      "\nOops! Class not found.\n",
      "Available classes in this package are: sds_100, sds_192, sds_220, sds_291"
    )
  }

  # actual code for loading packages starts here!

  # this looks up the packages tied to the specified class in our vector list and assigns it to pkgs
  loaded <- setNames(logical(length(sds_class)), sds_class)
  pkgs <- class_packages[[sds_class]]

  #for loop that libraries/installs
  # trycatch in case installation is weird for some rzn
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


