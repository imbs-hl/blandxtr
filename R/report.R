#' @title Create report for advanced Bland Altman-analysis
#'
#' @description \code{report} returns a report of results (tables and figures)
#' of advanced Bland Altman-analysis as html-, pdf- or word-document.
#'
#' @author Inga Koenemund \email{inga.koenemund@@web.de}
#'
#' @param res A list (blandxtr S3 object) from \code{blandxtr}-function
#' containing all results from advanced Bland Altman-analysis
#' @param output_format 'html_document' (default), 'pdf_document' or
#' 'word_document'
#' @param output_dir String specifying the directory for storing the output file
#'
#' @return A report of advanced Bland Altman-analysis' results.
#'
#' @export

report <- function(res, output_format, output_dir){
  # -----------------------
  # setting default values for 'output_format' and 'output_dir'

  if (missing(output_format)) {
    output_format <- 'html_document'
    warning("Variable `output_format` is missing. Setting to 'html_document'.")
  }

  if (missing(output_dir)) {
    output_dir <- getwd()
    warning("Variable `output_dir` is missing. Check your current working
      directory to find the report.")
  }
  # -----------------------
  # generate tables and figures to be displayed in the report

  tab <- generate_tables(res)
  fig <- plot(res, 3)

  # -----------------------
  rmarkdown::render(input = system.file("rmd", "report.rmd",
      package = "blandxtr"), output_format = output_format,
      params = list(tab = tab, fig = fig),
      output_dir = output_dir)
}
