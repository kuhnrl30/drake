% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find.R
\name{find_cache}
\alias{find_cache}
\title{Search up the file system for the nearest drake cache.}
\usage{
find_cache(path = getwd(),
  directory = basename(drake::default_cache_path()))
}
\arguments{
\item{path}{starting path for search back for the cache.
Should be a subdirectory of the drake project.}

\item{directory}{Name of the folder containing the cache.}
}
\value{
File path of the nearest drake cache or \code{NULL}
if no cache is found.
}
\description{
Only works if the cache is a file system in a
hidden folder named \code{.drake} (default).
}
\examples{
\dontrun{
test_with_dir("Quarantine side effects.", {
load_basic_example() # Get the code with drake_example("basic").
make(my_plan) # Run the project, build the target.
# Find the file path of the project's cache.
# Search up through parent directories if necessary.
find_cache()
})
}
}
\seealso{
\code{\link{drake_plan}}, \code{\link{make}},
}
