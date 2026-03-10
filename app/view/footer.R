# app/view/footer.R

box::use(
  cranlogs[cran_downloads],
  dplyr[filter, pull, summarize],
  scales[comma],
  shiny[
    div, moduleServer, NS, p, reactive, renderText, selectInput,
    tagList, tags, textOutput
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)

  tagList(
    tags$footer(
      class = "footer",
      textOutput(ns("package")),
      tags$ul(
        tags$li(textOutput(ns("footer_text_1"))),
        tags$li(textOutput(ns("footer_text_2"))),
        tags$li(textOutput(ns("footer_text_3"))),
        tags$li(textOutput(ns("footer_text_4")))
      ),
      p("*Download tracking with Cloudflare began February 15, 2026")
    )
  )
}

#' @param data Reactive. Tibble of downloaded data
#' @param project Reactive. Character, "nascar" or "nhanes"
#' @param type Reactive. Character, "stats" or "raw"
#' @param start_date Reactive. Date object from dateInput
#' @return Footer:
#'   packageName:
#'   - Total CRAN package downloads: [pkg_downloads_total]
#'   - Total CRAN package downloads since [date]: [pkg_downloads_since]
#'   - Total data file downloads: [file_downloads]
#'   - Total data file downloads: [file_downloads_since]
#' @export
server <- function(id, data, project, type, start_date) {
  moduleServer(id, function(input, output, session) {
    package <- reactive({
      if (project() == "nascar") "nascaR.data" else "nhanesdata"
    })

    output$package <- renderText({
      sprintf("%s: ", package())
    })

    pkg_downloads_total <- reactive({
      cran_downloads(package(), from = "2020-01-01") |>
        summarize(total = sum(count, na.rm = TRUE)) |>
        pull(total) |>
        comma()
    })

    output$footer_text_1 <- renderText({
      sprintf(
        "Total CRAN package downloads: %s",
        pkg_downloads_total()
      )
    })

    pkg_downloads_since <- reactive({
      cran_downloads(package(), from = as.character(start_date())) |>
        summarize(total = sum(count, na.rm = TRUE)) |>
        pull(total) |>
        comma()
    })

    the_date <- reactive(format(start_date(), "%B %e, %Y"))

    output$footer_text_2 <- renderText({
      sprintf(
        "Total CRAN package downloads since %s: %s",
        the_date(), pkg_downloads_since()
      )
    })

    file_downloads <- reactive({
      nrow(data()) |> comma()
    })

    output$footer_text_3 <- renderText({
      sprintf("Total data file downloads: %s", file_downloads())
    })

    file_downloads_since <- reactive({
      data() |>
        filter(time >= start_date()) |>
        nrow() |>
        comma()
    })

    output$footer_text_4 <- renderText({
      sprintf(
        "Total data file downloads since %s: %s",
        the_date(), file_downloads_since()
      )
    })
  })
}
