# app/logic/line_plot.R

box::use(
  dplyr[
    arrange, filter, group_by, mutate, n, pull, row_number,
    slice_max, summarize
  ],
  echarts4r[
    e_charts, e_color, e_line, e_legend, e_title, e_tooltip,
    e_x_axis, e_y_axis
  ],
  htmlwidgets[JS],
  stringr[str_remove],
)

#' Create a line chart of raw data over time
#' @param data Tibble. Raw download data
#' @param project Character. "nascar" or "nhanes"
#' @param type Character. "raw" or "stats"
#' @param start_date Date. Start date from dateInput
#' @export
line_plot <- function(data, project, type, start_date) {
  if (project == "nascar") {
    name <- "nascaR.data"
  } else {
    name <- "nhanesdata"
  }

  data <- if (type == "stats") {
    data |>
      filter(time >= start_date) |>
      summarize(count = n(), .by = file)
  } else {
    data |> filter(time >= start_date)
  }

  reduced <- data |>
    mutate(file = toupper(file)) |>
    mutate(time = as.Date(unlist(time), format = "%Y-%m-%d")) |>
    arrange(time) |>
    mutate(
      count = row_number(file),
      .by = file
    )

  top_files <- reduced |>
    summarize(max_count = max(count), .by = file) |>
    slice_max(max_count, n = 10) |>
    pull(file)

  chart <- reduced |>
    filter(file %in% top_files) |>
    group_by(file) |>
    e_charts(time) |>
    e_line(serie = count) |>
    e_color(c(
      "firebrick", "black", "gold", "#984ea3", "#ff7f00",
      "#a65628", "#f781bf", "#999999", "#66c2a5", "#fc8d62"
    )) |>
    e_y_axis(
      name = "Downloads",
      nameLocation = "middle",
      nameGap = 35,
      nameTextStyle = list(
        fontWeight = "bold",
        color = "black"
      )
    ) |>
    e_legend(type = "scroll", bottom = 0) |>
    e_title(
      text = sprintf("%s File Type Downloads", name),
      subtext = sprintf("Since %s", format(start_date, "%B %e, %Y"))
    ) |>
    e_tooltip(
      backgroundColor = "#e0e0e0",
      formatter = JS("
        function(params) {
          // console.log(params);
          // using the index of 1 for mapping to y-axis
          // mapping: x: 0, y: 1
          return params.seriesName + ': <br>' + params.value[1] + ' Downloads'
        }
      ")
    )

  chart
}
