# app/view/chart.R

box::use(
  echarts4r[echarts4rOutput, renderEcharts4r],
  shiny[div, moduleServer, NS],
)

box::use(
  app / logic / bar_plot,
  app / logic / line_plot,
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  div(
    class = "component-box",
    echarts4rOutput(ns("plot"))
  )
}

#' Render either bar or line plot
#' @param data Reactive. Tibble of downloaded data (counted or raw)
#' @param project Reactive. Character, "nascar" or "nhanes"
#' @param type Reactive. Character, "stats" or "raw"
#' @param start_date Reactive. Date object from dateInput
#' @export
server <- function(id, data, project, type, start_date) {
  moduleServer(id, function(input, output, session) {
    # call the reactives for data(), project(), and type()
    # inside the render function to unwrap the reactive object

    output$plot <- renderEcharts4r(
      if (type() == "stats") {
        bar_plot$bar_plot(data(), project(), type(), start_date())
      } else {
        line_plot$line_plot(data(), project(), type(), start_date())
      }
    )
  })
}
