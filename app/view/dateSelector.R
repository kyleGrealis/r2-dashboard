# app/view/dateSelector.R

box::use(
  shiny[dateInput, div, moduleServer, NS, reactive, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      dateInput(
        ns("date"),
        label = "Start Date:",
        min = as.Date("2026-02-15"),
        max = Sys.Date(),
        value = as.Date("2026-02-15")
      )
    )
  )
}

#' @return Reactive. Date object from dateInput
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$date)
  })
}
