#' @title Limits of agreement (LoA)
#'
#' @description \code{loa} returns limits of agreement (LoA).
#' Calculation is based on a method proposed by Bland and Altman (1999).
#'
#' @author Inga Koenemund \email{inga.koenemund@@web.de}
#'
#' @param d mean of all differences
#' @param sd_d standard deviation of d
#' @param beta for 100*(1-beta)\%-confidence interval around bias
#'
#' @return A list with the following elements is returned
#' \itemize{
#'  \item{\code{loa_l}} {lower limit of agreement}
#'  \item{\code{loa_u}} {upper limit of agreement}
#' }
#'
#' @export
#'

# ---------------------------
# limits of agreement (loa)
 loa <- function(d, sd_d, beta){

   # -----------------------------------------
   # check input
   coll <- checkmate::makeAssertCollection()
   checkmate::assert_numeric(d, add = coll)
   checkmate::assert_numeric(sd_d, add = coll)
   checkmate::assert_numeric(beta, lower = 0, upper = 1, add = coll)
   checkmate::reportAssertions(coll)

   # -----------------------------------------
   # calculate lower limit of agreement
   z <- qnorm(1-beta/2, mean = 0, sd = 1, lower.tail = TRUE, log.p = FALSE)
   loa_l <- d-(z*sd_d)

   # calculate upper limit of agreement
   loa_u <- d+(z*sd_d)
   rm(z)

   # -----------------------------------------
   return(
     list(
       loa_l = loa_l,
       loa_u = loa_u
     )
   )
 }
