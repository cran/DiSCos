% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DiSCo.R
\name{DiSCo}
\alias{DiSCo}
\title{Distributional Synthetic Controls}
\usage{
DiSCo(
  df,
  id_col.target,
  t0,
  M = 1000,
  G = 1000,
  num.cores = 1,
  permutation = FALSE,
  q_min = 0,
  q_max = 1,
  CI = FALSE,
  CI_placebo = TRUE,
  boots = 500,
  cl = 0.95,
  graph = FALSE,
  qmethod = NULL,
  seed = NULL,
  simplex = FALSE
)
}
\arguments{
\item{df}{Data frame or data table containing the distributional data for the target and control units. The data table should contain the following columns:
\itemize{
\item \code{y_col } A numeric vector containing the outcome variable for each unit. Units can be individuals, states, etc., but they should be nested within a larger unit (e.g. individuals or counties within a state)
\item \code{id_col } A numeric vector containing the aggregate IDs of the units. This could be, for example, the state if the units are counties or individuals
\item \code{time_col } A vector containing the time period of the observation for each unit. This should be a monotonically increasing integer.
}}

\item{id_col.target}{Variable indicating the name of the target unit, as specified in the id_col column of the data table.
This variable can be any type, as long as it is the same type as the id_col column of the data table.}

\item{t0}{Integer indicating period of treatment.}

\item{M}{Integer indicating the number of control quantiles to use in the DiSCo method. Default is 1000.}

\item{G}{Integer indicating the number of grid points for the grid on which the estimated functions are evaluated. Default is 1000.}

\item{num.cores}{Integer, number of cores to use for parallel computation. Default is 1. If the \code{permutation} or \code{CI} arguments are set to TRUE, this can be slow and it is recommended to set this to 4 or more, if possible.
If you get an error in "all cores" or similar, try setting num.cores=1 to see the precise error value.}

\item{permutation}{Logical, indicating whether to use the permutation method for computing the optimal weights. Default is FALSE.}

\item{q_min}{Numeric, minimum quantile to use. Set this together with \code{q_max} to restrict the range of quantiles used to construct the synthetic control. Default is 0 (all quantiles).}

\item{q_max}{Numeric, maximum quantile to use. Set this together with \code{q_min} to restrict the range of quantiles used to construct the synthetic control. Default is 1 (all quantiles).}

\item{CI}{Logical, indicating whether to compute confidence intervals for the counterfactual quantiles. Default is FALSE.}

\item{CI_placebo}{Logical, indicating whether to compute confidence intervals for the pre-treatment periods. Default is TRUE.
If you have a lot of pre-treatment periods, setting this to FALSE can speed up the computation.}

\item{boots}{Integer, number of bootstrap samples to use for computing confidence intervals. Default is 500.}

\item{cl}{Numeric, confidence level for the (two-sided) confidence intervals.}

\item{graph}{Logical, indicating whether to plot the permutation graph as in Figure 3 of the paper. Default is FALSE.}

\item{qmethod}{Character, indicating the method to use for computing the quantiles of the target distribution. The default is NULL, which uses the \code{\link[stats]{quantile}} function from the stats package.
Other options are "\code{\link[evmix]{qkden}}" (based on smoothed kernel density function) and "\code{\link[extremeStat:distLquantile]{extreme}}" (based on parametric extreme value distributions).
Both are substantially slower than the default method but may be useful for fat-tailed distributions with few data points at the upper quantiles. Alternatively, one could use the q_max option to restrict the range of quantiles used.}

\item{seed}{Integer, seed for the random number generator. This needs to be set explicitly in the function call, since it will invoke \code{\link[base]{RNGkind}} which will set the seed for each core
when using parallel processes. Default is NULL, which does not set a seed.}

\item{simplex}{Logical, indicating whether to use to constrain the optimal weights to the unit simplex. Default is FALSE, which only constrains the weights to sum up to 1 but allows them to be negative.}
}
\value{
A list containing, for each time period, the elements described in the return argument of \code{\link{DiSCo_iter}}, as well as the following additional elements:
\itemize{
\item \code{DiSco}
\itemize{
\item \code{CI } A list with the confidence intervals and standard errors for the counterfactual quantiles, if \code{CI} is TRUE and for the periods specified in \code{CI_periods}.
See the output of \code{\link{DiSCo_CI}} for details.
\item \code{quantile } The counterfactual quantiles for the target unit.
\item \code{weights } The optimal weights for the target unit.
\item \code{cdf } The counterfactual CDF for the target unit.
}

\item \code{perm } A \code{\link{permut}} object containing the results of the permutation method, if \code{permutation} is TRUE.
Call \code{summary} on this object to print the overall results of the permutation test.
}
}
\description{
This function implements the distributional synthetic controls (DiSCo) method from \insertCite{gunsilius2023distributional;textual}{DiSCos}.
as well as the alternative mixture of distributions approach.
}
\details{
This function is called for every time period in the DiSCo function. It implements the DiSCo method for a single time period, as well as the mixture of distributions approach.
The corresponding results for each time period can be accessed in the \code{results.periods} list of the output of the DiSCo function. The DiSCo function returns the average weight for each unit across all periods,
calculated as a uniform mean, as well as the counterfactual target distribution produced as the weighted average of the control distributions for each period, using these averaged weights.
}
\references{
\insertAllCited()
}
