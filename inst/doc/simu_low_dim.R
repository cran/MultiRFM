## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----eval = FALSE-------------------------------------------------------------
# library(MultiRFM)
# trace_statistic_fun <- function(H, H0){
# 
#   tr_fun <- function(x) sum(diag(x))
#   mat1 <- t(H0) %*% H %*% qr.solve(t(H) %*% H) %*% t(H) %*% H0
# 
#   tr_fun(mat1) / tr_fun(t(H0) %*% H0)
# 
# }
# trace_list_fun <- function(Hlist, H0list){
#   trvec <- rep(NA, length(Hlist))
#   for(i in seq_along(trvec)){
#     trvec[i] <- trace_statistic_fun(Hlist[[i]], H0list[[i]])
#   }
#   return(mean(trvec))
# }

## ----eval = FALSE-------------------------------------------------------------
# nu <- 3 # nu is set to
# p <- 100
# nvec <- c(150,200);  q <- 3;qs <- c(2,2); S <- length(nvec)
# sigma2_eps <- 1
# datList <- gendata_simu_multi(seed=1, nvec=nvec, p=p, q=q, qs=qs, rho=c(5,5), err.type='mvt', sigma2_eps = sigma2_eps, nu=nu)
# 
# 

## ----eval = FALSE-------------------------------------------------------------
# methodNames <- c("MultiRFM", "MSFA-CAVI", "MSFA-SVI")
# metricMat <- matrix(NA, nrow=length(methodNames), ncol=5)
# colnames(metricMat) <- c('A_tr', 'B_tr',  'F_tr', 'H_tr', 'Time')
# row.names(metricMat) <- methodNames
# XList <- datList$Xlist;
# 
# res <- MultiRFM(XList, q=q, qs=qs)
# #str(res)
# metricMat["MultiRFM",'Time'] <- res$time_use
# metricMat["MultiRFM",'A_tr'] <- trace_statistic_fun(res$A, datList$A0)
# metricMat["MultiRFM",'B_tr'] <- trace_list_fun(res$B, datList$Blist0)
# metricMat["MultiRFM",'F_tr'] <- trace_list_fun(res$F, datList$Flist)
# metricMat["MultiRFM",'H_tr'] <- trace_list_fun(res$H, datList$Hlist)
# 
# 

## ----eval = FALSE-------------------------------------------------------------
# X_s <- lapply(XList, scale, scale=FALSE)
# hmu <- sapply(XList, colMeans)
# library(VIMSFA)
# ### MSFA-CAVI
# print("MSFA-CAVI")
# tic <- proc.time()
# cavi_est <- cavi_msfa(X_s,  K=q, J_s=qs)
# toc <- proc.time()
# time_cavi <- toc[3] - tic[3]
# hLam <- Reduce(cbind, cavi_est$mean_psi_s)
# hF_cavi <- hH_cavi <- list()
# for(s in 1:S){
#   # s <- 1
#   hF_cavi[[s]] <- t(Reduce(cbind, cavi_est$mean_f[[s]]))
#   hH_cavi[[s]] <- t(Reduce(cbind, cavi_est$mean_l[[s]]))
# }
# 
# metricMat["MSFA-CAVI",'Time']  <- time_cavi
# metricMat["MSFA-CAVI",'A_tr']  <- trace_statistic_fun(cavi_est$mean_phi, datList$A0)
# metricMat["MSFA-CAVI",'B_tr']  <- trace_list_fun(cavi_est$mean_lambda_s, datList$Blist0)
# metricMat["MSFA-CAVI",'F_tr'] <- trace_list_fun(hF_cavi, datList$Flist)
# metricMat["MSFA-CAVI",'H_tr'] <- trace_list_fun(hH_cavi, datList$Hlist)
# 

## ----eval = FALSE-------------------------------------------------------------
# print("MSFA-SVI")
# tic <- proc.time()
# svi_est <- svi_msfa(X_s, K=q, J_s=qs, verbose = 0)
# toc <- proc.time()
# time_svi <- toc[3] - tic[3]
# hLam <- Reduce(cbind, svi_est$mean_psi_s)
# hF_cavi <- hH_cavi <- list()
# for(s in 1:S){
#   # s <- 1
#   hF_cavi[[s]] <- t(Reduce(cbind, svi_est$mean_f[[s]]))
#   hH_cavi[[s]] <- t(Reduce(cbind, svi_est$mean_l[[s]]))
# }
# 
# metricMat["MSFA-SVI",'Time']  <- time_cavi
# metricMat["MSFA-SVI",'A_tr']  <- trace_statistic_fun(svi_est$mean_phi, datList$A0)
# metricMat["MSFA-SVI",'B_tr']  <- trace_list_fun(svi_est$mean_lambda_s, datList$Blist0)
# metricMat["MSFA-SVI",'F_tr'] <- trace_list_fun(hF_cavi, datList$Flist)
# metricMat["MSFA-SVI",'H_tr'] <- trace_list_fun(hH_cavi, datList$Hlist)
# 

## ----eval = FALSE-------------------------------------------------------------
# 
# 
# dat_metric <- data.frame(metricMat)
# dat_metric$Method <- factor(row.names(dat_metric), levels=row.names(dat_metric))

## ----eval = FALSE, fig.width=13, fig.height=5---------------------------------
# library(cowplot)
# library(ggplot2)
# p1 <- ggplot(data=subset(dat_metric, !is.na(A_tr)), aes(x= Method, y=A_tr, fill=Method)) + geom_bar(stat="identity") + xlab(NULL) + scale_x_discrete(breaks=NULL) + theme_bw(base_size = 16)
# p2 <- ggplot(data=subset(dat_metric, !is.na(F_tr)), aes(x= Method, y=F_tr, fill=Method)) + geom_bar(stat="identity") + xlab(NULL) + scale_x_discrete(breaks=NULL)+ theme_bw(base_size = 16)
# p3 <- ggplot(data=subset(dat_metric, !is.na(B_tr)), aes(x= Method, y=B_tr, fill=Method)) + geom_bar(stat="identity") + xlab(NULL) + scale_x_discrete(breaks=NULL) + theme_bw(base_size = 16)
# p4 <- ggplot(data=subset(dat_metric, !is.na(H_tr)), aes(x= Method, y=H_tr, fill=Method)) + geom_bar(stat="identity") + xlab(NULL) + scale_x_discrete(breaks=NULL)+ theme_bw(base_size = 16)
# p5 <- ggplot(data=subset(dat_metric, !is.na(Time)), aes(x= Method, y=Time, fill=Method)) + geom_bar(stat="identity") + xlab(NULL) + scale_x_discrete(breaks=NULL)+ theme_bw(base_size = 16)
# plot_grid(p1,p2,p3, p4,  p5, nrow=2, ncol=3)

## ----eval = FALSE-------------------------------------------------------------
# 
# datList <- gendata_simu_multi(seed=1, nvec=nvec, p=p, q=q, qs=qs, rho=c(5,5), err.type='mvt', sigma2_eps =
#                                 sigma2_eps, nu=3)
# XList <- datList$Xlist;
# q_max <- 6; qs_max <- 4
# hq.list <- selectFac.MultiRFM(XList,  q_max=q_max, qs_max=qs_max, verbose = FALSE)
# message("hq = ", hq.list$q, " VS true q = ", q)
# message("hqs.vec = ", paste(hq.list$qs, collapse =", "), " VS true qs.vec = ", paste(qs, collapse =", "))

## -----------------------------------------------------------------------------
sessionInfo()

