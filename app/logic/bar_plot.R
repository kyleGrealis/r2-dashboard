# app/logic/bar_plot.R

box::use(
  dplyr[filter, mutate, n, summarize],
  echarts4r[
    e_charts, e_bar, e_legend, e_x_axis, e_y_axis, e_title, e_tooltip
  ],
  htmlwidgets[JS],
  stringr[str_remove],
)

#' Create a bar chart of counted data
#' @param data Tibble. Counted download data
#' @param project Character. "nascar" or "nhanes"
#' @param type Character. "raw" or "stats"
#' @param start_date Date. Start date from dateInput
#' @export
bar_plot <- function(data, project, type, start_date) {
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

  chart <- data |>
    mutate(file = str_remove(file, "_series")) |>
    mutate(file = toupper(file)) |>
    e_charts(x = file) |>
    e_bar(
      count,
      color = "firebrick",
      itemStyle = list(
        borderWidth = 1.5,
        borderColor = "black",
        borderRadius = list(2, 2, 0, 0)
      )
    ) |>
    e_legend(show = FALSE) |>
    e_y_axis(
      name = "Downloads",
      nameLocation = "middle",
      nameGap = 35,
      nameTextStyle = list(
        fontWeight = "bold",
        color = "black"
      )
    ) |>
    e_title(
      text = sprintf("Total %s File Type Downloads", name),
      subtext = sprintf("Since %s", format(start_date, "%B %e, %Y"))
    ) |>
    e_tooltip(
      backgroundColor = "#e0e0e0",
      formatter = JS("
        function(params) {
          // using the index of 1 for mapping to y-axis
          // mapping: x: 0, y: 1
          return params.name + ': ' + params.value[1] + '<br> Downloads'
        }
      ")
    )

  chart
}
