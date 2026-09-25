library(shiny)
library(tidyverse)
library(htmltools)
library(htmlwidgets)
library(mapgl)
library(leaflet)
library(ktheme)
library(classInt)
library(bibliotools)
library(sf)

random_orglist <- function(n, lookup) {

  random_orgs <- sample(lookup$ror_id, n, replace = FALSE)
  random_size <- rpois(n, 100)

  data.frame(ror_id = random_orgs,
             npubs = random_size) |>
    inner_join(lookup, by = "ror_id") |>
    rename(lon = lng, orgname = name) |>
    select(orgname, npubs, lat, lon)
}

lookup <- get_ror_lookup()

orglist <- random_orglist(10, lookup)

copub_mapgl <- function(orglist, max_radius) {

  pts <- orglist |>
    mutate(size = max_radius * sqrt(npubs / max(npubs))) |>
    st_as_sf(coords = c("lon", "lat"), crs = 4326)

  maplibre(style = carto_style("voyager"),
           projection = "mercator",
           renderWorldCopies = FALSE) |>
    add_circle_layer(
      id = "points",
      source = pts,
      circle_color  = kth_colors("red"),
      circle_radius = get_column("size"),
      circle_opacity = 0.8,
      circle_stroke_color = "white",
      circle_stroke_width = 1,
      popup   = "orgname",
      tooltip = "orgname"
    )
}


server <- function(input, output, session) {

  output$leaf <- renderLeaflet(copub_leaflet(orglist))

  output$mapgl <- renderMaplibre(copub_mapgl(orglist, max_radius = 10))

}

ui <- fluidPage(

  titlePanel("Test Leaflet vs MapGL"),

  mainPanel(
    # Output placeholders: the ID matches output$<id> in the server
    leafletOutput("leaf"),
    maplibreOutput("mapgl")
  )
)

shinyApp(ui, server)
