# app/logic/data.R

box::use(
  dplyr[filter, mutate, n, select, summarize],
  httr2[request, req_dry_run, req_headers, req_perform, resp_body_json],
  jsonlite[fromJSON, toJSON],
  stringr[str_remove],
)

#' Pull raw download data
#' @param project Character. "nascar" or "nhanes"
#' @return Full raw data of by-file downloads
#' @export
data_pull <- function(project) {
  result <- request(sprintf(
    "https://%s.kylegrealis.com/raw", project
  )) |>
    req_headers("Content-Type" = "application/json") |>
    req_perform() |>
    resp_body_json() |>
    toJSON(pretty = TRUE) |>
    fromJSON() |>
    # Strip the .parquet from the filename
    mutate(
      file = str_remove(file, "\\.parquet"),
      time = as.Date(unlist(time))
    ) |>
    select(-project)

  result
}
