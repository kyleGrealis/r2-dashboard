# app/view/typeSelector.R

box::use(
  shiny[div, moduleServer, NS, reactive, selectInput, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      selectInput(
        ns("type"), "Data type",
        choices = c("counted" = "stats", "raw"),
        selected = "stats"
      )
    )
  )
}

#' @return Reactive. Character, "stats" or "raw"
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$type)
  })
}
