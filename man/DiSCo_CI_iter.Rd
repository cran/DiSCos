% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DiSCo_CI.R
\name{DiSCo_CI_iter}
\alias{DiSCo_CI_iter}
\title{DiSCo_CI_iter}
\usage{
DiSCo_CI_iter(
  t,
  controls_t,
  target_t,
  grid,
  T0,
  M = 1000,
  evgrid = seq(from = 0, to = 1, length.out = 1001),
  qmethod = NULL,
  qtype = 7,
  mixture = FALSE,
  simplex = FALSE,
  replace = TRUE
)
}
\arguments{
\item{t}{Time period}

\item{controls_t}{List of control unit data for given period}

\item{target_t}{List of target unit data for given period}

\item{grid}{Grid to recompute the CDF on if \code{mixture} option is chosen}

\item{T0}{Index of the last pre-treatment period}

\item{M}{Integer indicating the number of control quantiles to use in the DiSCo method. Default is 1000.}

\item{qmethod}{Character, indicating the method to use for computing the quantiles of the target distribution. The default is NULL, which uses the \code{\link[stats]{quantile}} function from the stats package.
Other options are "\code{\link[evmix]{qkden}}" (based on smoothed kernel density function) and "\code{\link[extremeStat:distLquantile]{extreme}}" (based on parametric extreme value distributions).
Both are substantially slower than the default method but may be useful for fat-tailed distributions with few data points at the upper quantiles. Alternatively, one could use the q_max option to restrict the range of quantiles used.}

\item{qtype}{Integer, indicating the type of quantile to compute when using  \code{\link[stats]{quantile}} in the \code{qmethod} argument.
The default 7. See the documentation for the \code{\link[stats]{quantile}} function for more information.}

\item{mixture}{Logical, indicating whether to use the mixture of distributions approach instead.
See Section 4.3. in \insertCite{gunsilius2023distributional;textual}{DiSCos}. This approach minimizes the distance between the CDFs
instead of the quantile functions, and is preferred for categorical variables. When working with such variables, one should
also provide a list of support points in the \code{grid.cat} parameter. When that is provided, this parameter is automatically set to TRUE. Default is FALSE.}

\item{simplex}{Logical, indicating whether to use to constrain the optimal weights to the unit simplex. Default is FALSE, which only constrains the weights to sum up to 1 but allows them to be negative.}

\item{replace}{Logical, indicating whether to sample with replacement when computing the bootstrap samples. Default is TRUE.}
}
\value{
The resampled counterfactual barycenter of the target unit
}
\description{
Function for computing the confidence intervals in the DiSCo method in a single period
}
\keyword{internal}
