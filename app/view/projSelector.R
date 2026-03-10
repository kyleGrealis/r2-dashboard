# app/view/projSelector.R

box::use(
  shiny[div, moduleServer, NS, reactive, selectInput, tagList],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    div(
      selectInput(
        ns("project"), "Project",
        choices = c("NASCAR" = "nascar", "NHANES" = "nhanes")
      )
    )
  )
}

#' @return Reactive. Character, "nascar" or "nhanes"
#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(input$project)
  })
}
