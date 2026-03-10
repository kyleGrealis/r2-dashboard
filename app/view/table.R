# app/view/table.R

box::use(
  dplyr[filter, n, summarize],
  reactable[reactable, reactableOutput, renderReactable],
  shiny[div, moduleServer, NS],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  div(
    class = "component-box",
    reactableOutput(ns("table"))
  )
}

#' Render a reactable table based on type (raw or counted)
#' @param data Reactive. Tibble of downloaded data (counted or raw)
#' @param type Reactive. Character, "stats" or "raw"
#' @param start_date Reactive. Date object from dateInput
#' @export
server <- function(id, data, type, start_date) {
  moduleServer(id, function(input, output, session) {
    output$table <- renderReactable({
      df <- if (type() == "stats") {
        data() |>
          filter(time >= start_date()) |>
          summarize(count = n(), .by = file)
      } else {
        data() |> filter(time >= start_date())
      }

      reactable(df, defaultPageSize = 6, searchable = TRUE)
    })
  })
}
