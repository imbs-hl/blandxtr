#' @title Helper function for main method for blandxtr
#'
#' @description \code{main_pre} performs advanced Bland Altman-analysis
#' as proposed by Olofsen et al. (2015) without calculation of
#' confidence intervals. Helper function for \code{blandxtr} which performs
#' the whole analysis.
#'
#' @author Inga Koenemund \email{inga.koenemund@@web.de}
#'
#' @param bt number of bootstrap samples
#' @param input_dt data.table with input dataset
#' @param bias_alt set TRUE for alternative calculation of bias (small
#' within-subject variance) and its variance, set FALSE for standard calculation
#' of bias (small between-subjects variance) and its variance
#' @param beta for 100*(1-beta)\%-confidence interval around bias
#'
#' @note "_mod" labels results based on modified analysis of variance
#'
#' @return A list containing the return values of all used functions.
#'
#' @export
#'

main_pre <- function (input_dt, bt, bias_alt, beta) {

  # -----------------------------------------
  # check input
  coll <- checkmate::makeAssertCollection()
  checkmate::assert_data_table(input_dt, add = coll)
  checkmate::assert_int(bt, add = coll)
  checkmate::assert_logical(bias_alt, add = coll)
  checkmate::assert_numeric(beta, lower = 0, upper = 1, add = coll)
  checkmate::reportAssertions(coll)
  # -----------------------------------------

  # -----------------------------------------
  # calculate basic variables
  bv <- basic_variables(input_dt)

  # -----------------------------------------
  # analysis of variances (standard and modified)
  var_tvv <- var_tvv(bv$n, bv$n_obs, bv$d, bv$d_a, bias_alt, bv$output_subjects,
    bv$output_measurements)

  # -----------------------------------------
  # calculate limits of agreement (loa) (standard and modified)

  # limits of agreement (based on standard analysis of variance)
  loa <- loa(bv$d, var_tvv$sd_d, beta)

  # limits of agreement (based on modified analysis of variance)
  loa_mod <- loa(bv$d_a, var_tvv$sd_d_mod, beta)

  # -----------------------------------------
  # calculate variance of limits of agreement (loa)

  # variance of loa (based on standard analysis of variance)
  var_loa <- var_loa (bv$n, bv$n_obs, var_tvv$bsv, var_tvv$wsv,
    bv$output_subjects, var_tvv$var_var_d, bias_alt, beta)

  # variance of loa (based on modified analysis of variance)
  var_loa_mod <- var_loa (bv$n, bv$n_obs, var_tvv$bsv_mod, var_tvv$wsv_mod,
    bv$output_subjects, var_tvv$var_var_d_mod, bias_alt, beta)

  # -----------------------------------------
  return(
    list(
      bv = bv,
      var_tvv = var_tvv,
      loa = loa,
      loa_mod = loa_mod,
      var_loa = var_loa,
      var_loa_mod = var_loa_mod
    )
  )
}
