#' @title Output a random tip about drake.
#' @description Tips are usually related to news and usage.
#' @export
#' @return A character scalar with a tip on how to use drake.
#' @examples
#' drake_tip() # Show a tip about using drake.
#' message(drake_tip()) # Print out a tip as a message.
drake_tip <- function() {
  tips <- c(
    "In drake >= 4.4.0, you can select subgraphs of the workflow graph:
     e.g. vis_drake_graph(..., from = some_targets, mode = \"out\", order = 2).
     See the new 'graph' vignette for more.",

    "Use diagnose() to retrieve diagnostic information on
     a target that fails to build.",

    "Predict the runtime of the next make() with predict_runtime().
     See also build_times() and rate_limiting_times().",

    "Use drake_example('basic') to generate code files
     for a minimal drake example walkthrough.",

    "See the vignettes at
     https://cran.r-project.org/package=drake/vignettes for
     in-depth tutorials and other thorough documentation.",

    "Use suppressPackageStartupMessages() to eliminate
     package startup messages like this one.",

    "Check out the \"future_lapply\" backends. Example:
    load_basic_example();
    future::plan(future::multisession);
    make(my_plan, parallelism = \"future_lapply\")",

    "Drake quickstart:
     load_basic_example();
     vis_drake_graph(my_plan);
     make(my_plan);
     vis_drake_graph(my_plan)"
  ) %>% wrap_text
  sample(tips, 1)
}

drake_message <- function() {
  packageStartupMessage(drake_tip())
}

wrap_text <- Vectorize(function(x) {
  paste(strwrap(x), collapse = "\n") %>% unname
},
"x")
