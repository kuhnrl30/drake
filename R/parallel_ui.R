#' @title Write the batchtools template file
#' from one of the built-in drake examples.
#' @description If there are multiple template files in the example,
#' only the first one (alphabetically) is written.
#' @export
#' @seealso \code{\link{drake_examples}}, \code{\link{drake_example}},
#' \code{\link{shell_file}}
#' @return \code{NULL} is returned,
#' but a batchtools template file is written.
#' @param example Name of the drake example
#' from which to take the template file.
#' Must be listed in \code{\link{drake_examples}()}.
#' @param to Character vector, where to write the file.
#' @param overwrite Logical, whether to overwrite an existing file of the
#' same name.
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' load_basic_example() # Get the code with drake_example("basic").
#' # List the drake examples. Only some have template files.
#' drake_examples()
#' # Write the batchtools template file from the SLURM example.
#' drake_batchtools_tmpl_file("slurm") # Writes batchtools.slurm.tmpl.
#' # Find batchtools.slurm.tmpl with the rest of the example's files.
#' drake_example("slurm") # Writes a new 'slurm' folder with more files.
#' # Run the basic example with a
#' # SLURM-powered parallel backend. Requires SLURM.
#' library(future.batchtools)
#' # future::plan(batchtools_slurm, template = "batchtools.slurm.tmpl") # nolint
#' # make(my_plan, parallelism = "future_lapply") # nolint
#' })
#' }
drake_batchtools_tmpl_file <- function(
  example = drake::drake_examples(),
  to = getwd(),
  overwrite = FALSE
){
  example <- match.arg(example)
  dir <- system.file(file.path("examples", example), package = "drake",
    mustWork = TRUE)
  files <- list.files(dir)
  template_files <- files[grepl("\\.tmpl$", files)]
  if (!length(template_files)){
    stop("No template files found for the ", example, " example.")
  }
  file <- file.path(dir, template_files[1])
  file.copy(from = file, to = to,
    overwrite = overwrite, recursive = TRUE)
  invisible()
}

#' @title List the types of supported parallel computing in drake.
#' @description These are the possible values of the
#' \code{parallelism} argument to \code{\link{make}()}.
#' @export
#' @seealso \code{\link{make}}, \code{\link{shell_file}}
#' @return Character vector listing the types of parallel
#' computing supported.
#'
#' @details Run \code{make(..., parallelism = x, jobs = n)} for any of
#' the following values of \code{x} to distribute targets over parallel
#' units of execution.
#' \describe{
#'   \item{'parLapply'}{launches multiple processes in a single R session
#'   using \code{parallel::\link{parLapply}()}.
#'   This is single-node, (potentially) multicore computing.
#'   It requires more overhead than the \code{'mclapply'} option,
#'   but it works on Windows. If \code{jobs} is \code{1} in
#'   \code{\link{make}()}, then no 'cluster' is created and
#'   no parallelism is used.}
#'
#'   \item{'mclapply'}{uses multiple processes in a single R session.
#'   This is single-node, (potentially) multicore computing.
#'   Does not work on Windows for \code{jobs > 1}
#'   because \code{\link{mclapply}()} is based on forking.}
#'
#'   \item{'future_lapply'}{
#'   opens up a whole trove of parallel backends
#'   powered by the \code{future} and \code{future.batchtools}
#'   packages. First, set the parallel backend globally using
#'   \code{future::plan()}.
#'   Then, apply the backend to your drake_plan
#'   using \code{make(..., parallelism = "future_lapply", jobs = ...)}.
#'   But be warned: the environment for each target needs to be set up
#'   from scratch, so this backend type is higher overhead than either
#'   \code{mclapply} or \code{parLapply}.
#'   Also, the \code{jobs} argument only applies to the imports.
#'   To set the max number of jobs, set the \code{workers}
#'   argument where it exists. For example, call
#'   \code{future::plan(multisession(workers = 4))},
#'   then call \code{\link{make}(your_plan, parallelism = "future_lapply")}.
#'   You might also try options(mc.cores = jobs),
#'   or see \code{?future::future::.options}
#'   for environment variables that set the max number of jobs.
#'   }
#'
#'   \item{'Makefile'}{uses multiple R sessions
#'   by creating and running a Makefile.
#'   For distributed computing on a cluster or supercomputer,
#'   try \code{\link{make}(..., parallelism = 'Makefile',
#'   prepend = 'SHELL=./shell.sh')}.
#'   You need an auxiliary \code{shell.sh} file for this,
#'   and \code{\link{shell_file}()}
#'   writes an example.
#'
#'   Here, Makefile-level parallelism is only used for
#'   targets in your workflow plan
#'   data frame, not imports. To process imported objects and files,
#'   drake selects the best parallel
#'   backend for your system and uses
#'   the number of jobs you give to the \code{jobs}
#'   argument to \code{\link{make}()}.
#'   To use at most 2 jobs for imports and at most 4 jobs
#'   for targets, run
#'   \code{make(..., parallelism = 'Makefile', jobs = 2, args = '--jobs=4')}
#'
#'   Caution: the Makefile generated by
#'   \code{\link{make}(..., parallelism = 'Makefile')}
#'   is NOT standalone. DO NOT run it outside of
#'   \code{\link{make}()} or \code{\link{make}()}.
#'   Also, Windows users will need to download and install Rtools.
#'   }
#' }
#'
#' @param distributed_only logical, whether to return only
#' the distributed backend types, such as \code{Makefile} and
#' \code{parLapply}
#'
#' @examples
#' # See all the parallel computing options.
#' parallelism_choices()
#' # See just the distributed computing options.
#' parallelism_choices(distributed_only = TRUE)
parallelism_choices <- function(distributed_only = FALSE) {
  local <- c(
    "parLapply",
    "mclapply"
  )
  distributed <- c(
    "Makefile",
    "future_lapply"
  )
  if (distributed_only){
    distributed
  } else {
    c(local, distributed)
  }
}

#' @title Show the default \code{parallelism} argument
#' to \code{\link{make}()} for your system.
#' @description Returns \code{'parLapply'} for Windows machines
#' and \code{'mclapply'} for other platforms.
#' @export
#' @seealso \code{\link{make}}, \code{\link{shell_file}}
#' @return The default parallelism option for your system.
#' @examples
#' default_parallelism()
default_parallelism <- function() {
  ifelse(on_windows(), "parLapply", "mclapply") %>%
    unname
}

#' @title Write an example \code{shell.sh} file required by
#' \code{make(..., parallelism = 'Makefile', prepend = 'SHELL=./shell.sh')}.
#' @description This function also does a `chmod +x`
#' to enable execute permissions.
#' @seealso \code{\link{make}}, \code{\link{max_useful_jobs}},
#' \code{\link{parallelism_choices}}, \code{\link{drake_batchtools_tmpl_file}},
#' \code{\link{drake_example}}, \code{\link{drake_examples}}
#' @export
#' @return The return value of the call to \code{file.copy()} that
#' wrote the shell file.
#' @param path file path of the shell file
#' @param overwrite logical, whether to overwrite a possible
#' destination file with the same name
#' @examples
#' \dontrun{
#' test_with_dir("Quarantine side effects.", {
#' # Write shell.sh to your working directory.
#' # Read the parallelism vignette to learn how it is used
#' # in Makefile parallelism.
#' shell_file()
#' })
#' }
shell_file <- function(
  path = "shell.sh",
  overwrite = FALSE
){
  from <- system.file("shell.sh", package = "drake", mustWork = TRUE)
  if (file.exists(path) & overwrite){
    warning("Overwriting file ", path)
  }
  invisible(file.copy(from = from, to = path, copy.mode = TRUE,
    overwrite = overwrite))
}
