#' @title DiSCo_per_iter
#' @description This function performs one iteration of the permutation test
#' @param c_df List of control units
#' @param c_df.q List of quantiles of control units
#' @param t_df List of target unit
#' @param idx Index of permuted target unit
#' @param grid_df Grids to evaluate CDFs on, only needed when `mixture=TRUE`
#' @inheritParams DiSCo
#' @return List of squared Wasserstein distances between the target unit and the control units
#' @keywords internal
DiSCo_per_iter <- function(c_df, c_df.q, t_df, T0, peridx, evgrid, idx, grid_df, M=1000,
                           ww=0, qmethod=NULL, qtype=7, q_min=0, q_max=1, simplex=FALSE,
                           mixture=FALSE){
    # One iteration of the permutation test

    #create new control and target
    pert=list()
    perc=list()
    perc.q=list()
    for (i in 1:length(c_df)){
      perc[[i]]=list()
      perc.q[[i]] <- matrix(0, ncol=length(c_df[[i]]),nrow=length(evgrid))
    }

    for (i in 1:length(perc)){
      perc[[i]][[1]]=t_df[[i]]
    }

    keepcon=peridx[-idx]

    for (i in 1:length(perc)){
      for (j in 1:length(keepcon)){
        perc[[i]][[j+1]] <- c_df[[i]][[keepcon[j]]]
        perc.q[[i]][,j+1] <- c_df.q[[i]][,keepcon[j]]
      }
    }

    for (i in 1:length(c_df)){
      pert[[i]]=c_df[[i]][[idx]]
    }


    #calculate lambda_t for t<=T0
    lambda_tp=list()

    if (!mixture) { # disco
      for (t in 1:T0){
        lambda_tp[[t]] <- DiSCo_weights_reg(perc[[t]], as.vector(pert[[t]]),  M=M, qmethod=qmethod, simplex=simplex, q_min=q_min, q_max=q_max)
      }
    } else {
      perc.cdf <- list()
      for (t in 1:length(perc)){ # mixture
        grid_t <- grid_df[[t]]
        mixt <- DiSCo_mixture(perc[[t]], as.vector(pert[[t]]), min(grid_t), max(grid_t), grid_t, M, simplex=simplex)

        if (t <= T0) lambda_tp[[t]] <- mixt$weights.opt
        perc.cdf[[t]] <- mixt$cdf
      }
    }


    #calculate the average optimal lambda (TODO: allow time-specific weights)
    if (length(ww)==1){
      w_t <- rep(1/T0, T0)
      lambda.opt <- matrix(unlist(lambda_tp),ncol=T0)%*%w_t
    } else{
      lambda.opt <- matrix(unlist(lambda_tp),ncol=T0)%*%ww
    }

    bc_t=list()
    target_q=list()

    if (!mixture) { ## disco
      #calculate the barycenters for each period
      for (t in 1:length(perc)){
        bc_t[[t]] <- DiSCo_bc(perc.q[[t]], lambda.opt,evgrid)
      }
      # computing the target quantile function
      for (t in 1:length(pert)){
        target_q[[t]] <- myQuant(pert[[t]], evgrid, qmethod, qtype=qtype)
      }
    } else { ## mixture
      #calculate the cdfs for each period
      for (t in 1:length(perc)){
        bc_t[[t]] <- perc.cdf[[t]][,-1] %*% lambda.opt # we're calling this "barycenter" for coding convenience
      }
      # computing the target quantile function
      for (t in 1:length(pert)){
        target_q[[t]] <- perc.cdf[[t]][,1]
      }
    }


    #squared Wasserstein distance between the target and the corresponding barycenter
    dist=c()
    for (t in 1:length(perc)){
      dist[t]=mean((bc_t[[t]] -target_q[[t]])**2)
    }
    #setTxtProgressBar(pb, i)

    return(dist)
}
