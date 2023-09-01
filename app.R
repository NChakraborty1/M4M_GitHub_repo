
#Nirali has been here
# FHM Engage - Interactive map
# This is a Shiny web application

# install.packages("shiny")
# install.packages("shinydashboard")
# install.packages("shinythemes")
# install.packages("leaflet")
# install.packages("leaflet.extras")
# install.packages("dplyr")
# install.packages("sf")
# install.packages("rsconnect")
# install.packages("shinyWidgets")


# import libraries
library(shiny)
library(shinythemes)
library(leaflet)
library(leaflet.extras)
library (sf)
library (dplyr)
library(shinyWidgets)
library(shinydashboard)
library(rsconnect)

# --------------- Load data ----------------
# Load the shapefile

# Region data for age all
shp_path_age_all <- "data/age_allv4.shp"
shp_df_all <- sf::st_read(dsn=shp_path_age_all)
shp_df_all = shp_df_all %>%
  rename("privFP_pop" ="prvFP_p",
         "w_pubFP_pop" = "w_pbFP_" ,
         "priv_stm_pop" = "prv_st_",
         "w_pubSTM_pop" = "w_pSTM_" ,
         "priv_inj_pop" = "prv_nj_",
         "w_pubInj_pop" = "w_pbIn_",
         "priv_imp_pop" = "prv_Im_",
         "w_pubImp_pop" = "w_pbIm_",
         "w_cneed_pop" = "w_cnd_p",
         "longitude" = "longitd",
         "latitude" = "latitud"
  )

all_ranges <- c(18000, 43000, 75000, 145000, 192563)
short_term_ranges <- c(15152, 35034, 55229, 90984, 275530)
injectables_ranges <- c(7279, 17940, 31810, 45077, 73972)
impant_ranges <- c(1452,4266,13909, 22099, 53167)

shp_df_all$all_cat_private <- findInterval(shp_df_all$privFP_pop, vec = all_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(all_cat_private = ifelse(all_cat_private == 0, "0000",
                                  ifelse(all_cat_private == 1, "18000",
                                         ifelse(all_cat_private == 2, "43000",
                                                ifelse(all_cat_private == 3, "75000",
                                                       ifelse(all_cat_private == 4, "145000",
                                                              ifelse(all_cat_private == 5, "192000","other")))))))

shp_df_all$all_cat_public <- findInterval(shp_df_all$w_pubFP_pop, vec = all_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(all_cat_public = ifelse(all_cat_public == 0, "0000",
                                 ifelse(all_cat_public == 1, "18000",
                                        ifelse(all_cat_public == 2, "43000",
                                               ifelse(all_cat_public == 3, "75000",
                                                      ifelse(all_cat_public == 4, "145000",
                                                             ifelse(all_cat_public == 5, "192000","other")))))))

shp_df_all$STM_cat_private <- findInterval(shp_df_all$priv_stm_pop, vec = short_term_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(STM_cat_private = ifelse(STM_cat_private == 0, "0000",
                                  ifelse(STM_cat_private == 1, "15000",
                                         ifelse(STM_cat_private == 2, "35000",
                                                ifelse(STM_cat_private == 3, "55000",
                                                       ifelse(STM_cat_private == 4, "90000",
                                                              ifelse(STM_cat_private == 5, "27000","other")))))))

shp_df_all$STM_cat_public <- findInterval(shp_df_all$w_pubSTM_pop, vec = short_term_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(STM_cat_public = ifelse(STM_cat_public == 0, "0000",
                                 ifelse(STM_cat_public == 1, "15000",
                                        ifelse(STM_cat_public == 2, "35000",
                                               ifelse(STM_cat_public == 3, "55000",
                                                      ifelse(STM_cat_public == 4, "90000",
                                                             ifelse(STM_cat_public == 5, "27000","other")))))))

shp_df_all$injec_cat_private <- findInterval(shp_df_all$priv_inj_pop, vec = injectables_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(injec_cat_private = ifelse(injec_cat_private == 0, "0000",
                                    ifelse(injec_cat_private == 1, "7000",
                                           ifelse(injec_cat_private == 2, "17000",
                                                  ifelse(injec_cat_private == 3, "31000",
                                                         ifelse(injec_cat_private == 4, "45000",
                                                                ifelse(injec_cat_private == 5, "73000","other")))))))

shp_df_all$injec_cat_public <- findInterval(shp_df_all$w_pubInj_pop, vec = injectables_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(injec_cat_public = ifelse(injec_cat_public == 0, "0000",
                                   ifelse(injec_cat_public == 1, "7000",
                                          ifelse(injec_cat_public == 2, "17000",
                                                 ifelse(injec_cat_public == 3, "31000",
                                                        ifelse(injec_cat_public == 4, "45000",
                                                               ifelse(injec_cat_public == 5, "73000","other")))))))

shp_df_all$impl_cat_private <- findInterval(shp_df_all$priv_imp_pop, vec = impant_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(impl_cat_private = ifelse(impl_cat_private == 0, "0000",
                                   ifelse(impl_cat_private == 1, "1400",
                                          ifelse(impl_cat_private == 2, "4200",
                                                 ifelse(impl_cat_private == 3, "13000",
                                                        ifelse(impl_cat_private == 4, "22000",
                                                               ifelse(impl_cat_private == 5, "53000","other")))))))

shp_df_all$impl_cat_public <- findInterval(shp_df_all$w_pubImp_pop, vec = impant_ranges, all.inside=T)
shp_df_all <- shp_df_all %>%
  mutate(impl_cat_public = ifelse(impl_cat_public == 0, "0000",
                                  ifelse(impl_cat_public == 1, "1400",
                                         ifelse(impl_cat_public == 2, "4200",
                                                ifelse(impl_cat_public == 3, "13000",
                                                       ifelse(impl_cat_public == 4, "22000",
                                                              ifelse(impl_cat_public == 5, "53000","other")))))))

# Region data for Age 15 to 24
shp_path_age_15_24 <- "data/age_14_24v4.shp"
shp_df_15_24 <- sf::st_read(dsn=shp_path_age_15_24)
shp_df_15_24 = shp_df_15_24 %>%
  rename("privFP_pop" ="prvFP_p",
         "w_pubFP_pop" = "w_pbFP_" ,
         "priv_stm_pop" = "prv_st_",
         "w_pubSTM_pop" = "w_pSTM_" ,
         "priv_inj_pop" = "prv_nj_",
         "w_pubInj_pop" = "w_pbIn_",
         "priv_imp_pop" = "prv_Im_",
         "w_pubImp_pop" = "w_pbIm_",
         "w_cneed_pop" = "w_cnd_p",
         "longitude" = "longitd",
         "latitude" = "latitud"
  )

shp_df_15_24$all_cat_private <- findInterval(shp_df_15_24$privFP_pop, vec = all_ranges)
shp_df_15_24$all_cat_public <- findInterval(shp_df_15_24$w_pubFP_pop, vec = all_ranges)
shp_df_15_24$STM_cat_private <- findInterval(shp_df_15_24$priv_stm_pop, vec = short_term_ranges)
shp_df_15_24$STM_cat_public <- findInterval(shp_df_15_24$w_pubSTM_pop, vec = short_term_ranges)
shp_df_15_24$injec_cat_private <- findInterval(shp_df_15_24$priv_inj_pop, vec = injectables_ranges)
shp_df_15_24$injec_cat_public <- findInterval(shp_df_15_24$w_pubInj_pop, vec = injectables_ranges)
shp_df_15_24$impl_cat_private <- findInterval(shp_df_15_24$priv_imp_pop, vec = impant_ranges)
shp_df_15_24$impl_cat_public <- findInterval(shp_df_15_24$w_pubImp_pop, vec = impant_ranges)


shp_df_15_24$all_cat_private <- findInterval(shp_df_15_24$privFP_pop, vec = all_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(all_cat_private = ifelse(all_cat_private == 0, "0000",
                                  ifelse(all_cat_private == 1, "1000",
                                         ifelse(all_cat_private == 2, "2000",
                                                ifelse(all_cat_private == 3, "3000",
                                                       ifelse(all_cat_private == 4, "4000",
                                                              ifelse(all_cat_private == 5, "5000","other")))))))

shp_df_15_24$all_cat_public <- findInterval(shp_df_15_24$w_pubFP_pop, vec = all_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(all_cat_public = ifelse(all_cat_public == 0, "0000",
                                 ifelse(all_cat_public == 1, "1000",
                                        ifelse(all_cat_public == 2, "2000",
                                               ifelse(all_cat_public == 3, "3000",
                                                      ifelse(all_cat_public == 4, "4000",
                                                             ifelse(all_cat_public == 5, "5000","other")))))))

shp_df_15_24$STM_cat_private <- findInterval(shp_df_15_24$priv_stm_pop, vec = short_term_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(STM_cat_private = ifelse(STM_cat_private == 0, "0000",
                                  ifelse(STM_cat_private == 1, "1000",
                                         ifelse(STM_cat_private == 2, "2000",
                                                ifelse(STM_cat_private == 3, "3000",
                                                       ifelse(STM_cat_private == 4, "4000",
                                                              ifelse(STM_cat_private == 5, "5000","other")))))))

shp_df_15_24$STM_cat_public <- findInterval(shp_df_15_24$w_pubSTM_pop, vec = short_term_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(STM_cat_public = ifelse(STM_cat_public == 0, "0000",
                                 ifelse(STM_cat_public == 1, "1000",
                                        ifelse(STM_cat_public == 2, "2000",
                                               ifelse(STM_cat_public == 3, "3000",
                                                      ifelse(STM_cat_public == 4, "4000",
                                                             ifelse(STM_cat_public == 5, "5000","other")))))))

shp_df_15_24$injec_cat_private <- findInterval(shp_df_15_24$priv_inj_pop, vec = injectables_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(injec_cat_private = ifelse(injec_cat_private == 0, "0000",
                                    ifelse(injec_cat_private == 1, "1000",
                                           ifelse(injec_cat_private == 2, "2000",
                                                  ifelse(injec_cat_private == 3, "3000",
                                                         ifelse(injec_cat_private == 4, "4000",
                                                                ifelse(injec_cat_private == 5, "5000","other")))))))

shp_df_15_24$injec_cat_public <- findInterval(shp_df_15_24$w_pubInj_pop, vec = injectables_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(injec_cat_public = ifelse(injec_cat_public == 0, "0000",
                                   ifelse(injec_cat_public == 1, "1000",
                                          ifelse(injec_cat_public == 2, "2000",
                                                 ifelse(injec_cat_public == 3, "3000",
                                                        ifelse(injec_cat_public == 4, "4000",
                                                               ifelse(injec_cat_public == 5, "5000","other")))))))
shp_df_15_24$impl_cat_private <- findInterval(shp_df_15_24$priv_imp_pop, vec = impant_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(impl_cat_private = ifelse(impl_cat_private == 0, "0000",
                                   ifelse(impl_cat_private == 1, "1000",
                                          ifelse(impl_cat_private == 2, "2000",
                                                 ifelse(impl_cat_private == 3, "3000",
                                                        ifelse(impl_cat_private == 4, "4000",
                                                               ifelse(impl_cat_private == 5, "5000","other")))))))

shp_df_15_24$impl_cat_public <- findInterval(shp_df_15_24$w_pubImp_pop, vec = impant_ranges, all.inside=T)
shp_df_15_24 <- shp_df_15_24 %>%
  mutate(impl_cat_public = ifelse(impl_cat_public == 0, "0000",
                                  ifelse(impl_cat_public == 1, "1000",
                                         ifelse(impl_cat_public == 2, "2000",
                                                ifelse(impl_cat_public == 3, "3000",
                                                       ifelse(impl_cat_public == 4, "4000",
                                                              ifelse(impl_cat_public == 5, "5000","other")))))))



# District aata for all 
dis_df_all_path <- "data/district_all.shp"
dis_df_all <- sf::st_read(dsn=dis_df_all_path)


# District age 14-24 
dis_df_14_24_path <- "data/district_15_24.shp"
dis_df_15_24 <- sf::st_read(dsn=dis_df_14_24_path)
dis_df_15_24 = dis_df_15_24 %>%
  rename("mcpr_pop"="mpcr_pop")

# ----------------- List choices --------------------
private_indicators =list(
  "All"="all_cat_private",
  "Short-term method" = "STM_cat_private",
  "Injectables" ="injec_cat_private",
  "Oral contraceptive pills" ="44",
  "Implant" = "impl_cat_private"
)

public_indicators =list(
  "All"="all_cat_public",
  "Short-term method" = "STM_cat_public",
  "Injectables" ="injec_cat_public",
  "Oral contraceptive pills" ="444",
  "Implant" = "impl_cat_public"
)

unmet = list(
  "All"="mc",
  "With financial capacity" = "cnp"
)

age_group = c("All women (Age: 15 - 49)" = "15-49","Young women (Age: 15 - 24)" = "15-24")
age_group_district = c("All women (Age: 15 - 49)" = "15-49a","Young women (Age: 15 - 24)" = "15-24a")

# District choices 

district_indicators = c("All"="mcpr_pop", "Unmet Need or Traditonal Users"= "cneed_pop")



# Create the mapping list 

c <- list(
  "all_cat_private" = "privFP_pop",
  "all_cat_public" = "w_pubFP_pop",
  "STM_cat_private" = "priv_stm_pop",
  "STM_cat_public" = "w_pubSTM_pop",
  "injec_cat_private" = "priv_inj_pop",
  "injec_cat_public" = "w_pubInj_pop",
  "impl_cat_private" = "priv_imp_pop",
  "impl_cat_public" = "w_pubImp_pop"
)

# ---------UI --------------
# Increase the maximum upload size to 160 MB 
options(shiny.maxRequestSize = 160*1024^2)
# Define the UI
ui <- dashboardPage(
  dashboardHeader(title = "FHM Engage: Private Sector Analysis"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Region", tabName = "region", icon = icon("dashboard")),
      menuItem("District", tabName = "district", icon = icon("dashboard")),
      menuItem("About", icon = icon("th"), tabName = "about")
    )
    
  ),
  dashboardBody(
    tags$style(HTML("
      .select-container {
        position: relative;
        z-index: 1; /* Ensure it's in front of the map */
      }
      .map-container {
        position: relative;
        z-index: 0; /* Lower z-index for the map */
      }
    ")),
    tabItems(
      tabItem(tabName = "region",
              h2("Market Size"),
              box(tabName = "region",
                  div(class = "select-container",
                      selectInput("private", label = "Private Modern Contraceptive Methods", choices = private_indicators, selected = "privFP_pop")),
                  # add map
                  div(class = "map-container", leafletOutput("map1"))),
              box(tabName = "region",
                  div(class = "select-container",
                      selectInput("public", label = "Public Modern Contraceptive Methods", choices = public_indicators, selected = "privFP_pop")),
                  # add map
                  div(class = "map-container", leafletOutput("map2"))),
              radioGroupButtons(
                inputId = "age_group",
                label = "Women Age Group",
                choices = age_group,
                justified = TRUE,
                individual = TRUE,
                checkIcon = list(
                  yes = tags$i(class = "fa fa-circle",
                               style = "color: steelblue"),
                  no = tags$i(class = "fa fa-circle-o",
                              style = "color: steelblue")),
                direction = "vertical"
              )
      ),
      tabItem(tabName = "district",
              h2("Market Size"),
              box(tabName = "district",
                  selectInput("district_mpcr", label = "Modern Contraceptive Methods", choices = district_indicators, selected = "mpcr_pop")),
              # add map
              leafletOutput("district_map"),
              radioGroupButtons(
                inputId = "age_group_district",
                label = "Women Age Group",
                choices = age_group_district,
                justified = TRUE,
                individual = TRUE,
                checkIcon = list(
                  yes = tags$i(class = "fa fa-circle",
                               style = "color: steelblue"),
                  no = tags$i(class = "fa fa-circle-o",
                              style = "color: steelblue")),
                direction = "vertical"
              )
      ),
      tabItem(tabName = "about",
              h3("How does it work?"),
              p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. \
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. \
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.\
    Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
              h3("Dashboard features"),
              p("add here"),
              h3("Contributors"),
              p("add here"),
              h3("Acknowledgements"),
              p("add here"),
              h3("Additional resources"),
              p("add here")
      )
    )
  )
)



# Define the server
server <- function(input, output, session) {
  
  # customised legend for polygon 
  addPolygonLegend <- function(map, palette, breaks, labels, position = "bottomright") {
    legend_colors <- lapply(palette, function(color) {
      sprintf("<i style='background:%s;'></i>", color)
    })
    
    legend_labels <- lapply(seq_along(labels), function(i) {
      sprintf("%s %s", legend_colors[[i]], labels[i])
    })
    
    map %>% addLegend(
      position = position,
      colors = palette,
      labels = legend_labels,
      title = "Legend",
      opacity = 1,
      layerId = "polygon_legend"
    )
  }
  
  
  
  # customised function legend for circle 
  addLegendCustom <- function(map, colors, labels, sizes, opacity = 0.5){
    colorAdditions <- paste0(colors, "; border-radius: 50%; width:", sizes, "px; height:", sizes, "px")
    labelAdditions <- paste0("<div style='display: inline-block;height: ", sizes, "px;margin-top: 4px;line-height: ", sizes, "px;'>", labels, "</div>")
    
    return(addLegend(map, colors = colorAdditions, labels = labelAdditions, opacity = opacity))
  }
  
  # Map 1
  output$map1 <- renderLeaflet({
    
    # select data
    selected_data <- switch(
      input$age_group,
      "15-49"= shp_df_all,
      "15-24"= shp_df_15_24
    )
    
    col_select1 <- as.numeric(selected_data[[input$private]])
    
    
    ############# ----------  
    privFP_pop <- selected_data$privFP_pop
    w_pubFP_pop <- selected_data$w_pubFP_pop
    priv_stm_pop <- selected_data$priv_stm_pop
    w_pubSTM_pop <- selected_data$w_pubSTM_pop
    priv_inj_pop <- selected_data$priv_inj_pop
    w_pubInj_pop <- selected_data$w_pubInj_pop
    priv_imp_pop <- selected_data$priv_imp_pop
    w_pubImp_pop <- selected_data$w_pubImp_pop
    
    # get column names here 
    col_select_corespond1 <- input$private
    
    
    if (col_select_corespond1 %in% names(c)) {
      # Get the corresponding dataframe name from the mapping
      df_name <- c[[col_select_corespond1]]
      
      # Fetch the dataframe using the df_name
      selected_df <- get(df_name)
      # Print the selected dataframe
          } else {
      cat("Input condition not found in the mapping.\n")
    }
    
    ############# -----------
    proportion_pop1 <- selected_df / selected_data$WRA_reg * 100
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%g Users<br/>%.2f%% of Women population",
      selected_data$ADM1_EN, selected_df, proportion_pop1
    ) %>% lapply(htmltools::HTML)
    
    
    # Legend polygon
    qpal <- colorFactor(palette = "YlGnBu", domain = col_select1)
 
    
    # Legend for circle
    circl_rad <- c(5, 25, 50)
    HC_den_fac <- findInterval(shp_df_all$HC_den, vec = circl_rad, all.inside=T)
    pharm_den_fac <- findInterval(shp_df_all$phrm_dn, vec = circl_rad, all.inside=T)
    adds_dn <- findInterval(shp_df_all$adds_dn, vec = circl_rad, all.inside=T)
    prvll_d <- findInterval(shp_df_all$prvll_d, vec = circl_rad, all.inside=T)

    
    leaflet(selected_data) %>%
      addTiles() %>%
      addPolygons(
        weight = 1, smoothFactor = 0.5,
        color = "white",
        opacity = 1.0, fillOpacity = 0.8,
        highlightOptions = highlightOptions(
          color = "blue", weight = 2,
          bringToFront = TRUE
        ),
        fillColor = ~qpal(col_select1),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = HC_den_fac * 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~HC_den, group = "Health facilities"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = pharm_den_fac* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~phrm_dn, group = "Pharmacies"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = adds_dn* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~adds_dn, group = "Addols"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = prvll_d* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~prvll_d, group = "Private facilities"
      ) %>%
      addLayersControl(  # Add a layer control to switch layers
        overlayGroups = c("Health facilities", "Pharmacies", "Addols", "Private facilities"),  # Specify the group name
        options = layersControlOptions(collapsed = TRUE)
      ) %>%
      addLegendCustom("bottomleft", colors = c("red", "red", "red"), labels = c("5/100,000", "25/100,000", "50/100,000"), sizes = c(4, 6, 9)
      ) %>%
      hideGroup(c("Health facilities", "Pharmacies", "Addols", "Private facilities"))%>%
      # add legend to Est.
      addLegend(
        "bottomright",
        pal = qpal,
        values = ~col_select1,
        title = NULL,
        opacity = 1
      )
    
  })
  # Map 2
  output$map2 <- renderLeaflet({
    
    # select data
    selected_data1 <- switch(
      input$age_group,
      "15-49"= shp_df_all,
      "15-24"= shp_df_15_24
    )
    
    col_select <- as.numeric(selected_data1[[input$public]])
    
    
    ############# ----------  
    privFP_pop <- selected_data1$privFP_pop
    w_pubFP_pop <- selected_data1$w_pubFP_pop
    priv_stm_pop <- selected_data1$priv_stm_pop
    w_pubSTM_pop <- selected_data1$w_pubSTM_pop
    priv_inj_pop <- selected_data1$priv_inj_pop
    w_pubInj_pop <- selected_data1$w_pubInj_pop
    priv_imp_pop <- selected_data1$priv_imp_pop
    w_pubImp_pop <- selected_data1$w_pubImp_pop
    
    
    # add column names here 
    col_select_corespond <- input$public
   
    if (col_select_corespond %in% names(c)) {
      # Get the corresponding dataframe name from the mapping
      df_name <- c[[col_select_corespond]]
      
      # Fetch the dataframe using the df_name
      selected_df1 <- get(df_name)
     
      #print(selected_df1)
    } else {
      cat("Input condition not found in the mapping.\n")
    }
    
    ############# -----------
    proportion_pop1 <- selected_df1 / selected_data1$WRA_reg * 100
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%g Users<br/>%.2f%% of Women population",
      selected_data1$ADM1_EN, selected_df1, proportion_pop1
    ) %>% lapply(htmltools::HTML)
    
    # Legend for polygon
    qpal <- colorFactor(palette = "YlGnBu", domain = col_select)
    
    # Legend for circle
    circl_rad <- c(5, 25, 50)
    HC_den_fac <- findInterval(shp_df_all$HC_den, vec = circl_rad, all.inside=T)
    pharm_den_fac <- findInterval(shp_df_all$phrm_dn, vec = circl_rad, all.inside=T)
    adds_dn <- findInterval(shp_df_all$adds_dn, vec = circl_rad, all.inside=T)
    prvll_d <- findInterval(shp_df_all$prvll_d, vec = circl_rad, all.inside=T)
    
    qpal_circles <- colorNumeric("red", domain = selected_data1$WRA_reg)
    circle_legend_labels <- seq(min(selected_data1$WRA_reg), max(selected_data1$WRA_reg), length.out = 5)
    
    leaflet(selected_data1) %>%
      addTiles() %>%
      addPolygons(
        weight = 1, smoothFactor = 0.5,
        color = "white",
        opacity = 1.0, fillOpacity = 0.8,
        highlightOptions = highlightOptions(
          color = "blue", weight = 2,
          bringToFront = TRUE
        ),
        fillColor = ~qpal(col_select),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = HC_den_fac * 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~HC_den, group = "Health facilities"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = pharm_den_fac* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~phrm_dn, group = "Pharmacies"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = adds_dn* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~adds_dn, group = "Addols"
      ) %>%
      addCircles(
        lng = ~longitude, lat = ~latitude, weight = 1,
        radius = prvll_d* 10000, 
        color = "red", fillOpacity = 0.5,
        popup = ~prvll_d, group = "Private facilities"
      ) %>%
      addLayersControl(  # Add a layer control to switch layers
        overlayGroups = c("Health facilities", "Pharmacies", "Addols", "Private facilities"),  # Specify the group name
        options = layersControlOptions(collapsed = TRUE)
      ) %>%
      addLegendCustom("bottomleft", colors = c("red", "red", "red"), labels = c("5/100,000", "25/100,000", "50/100,000"), sizes = c(4, 6, 9)
      ) %>%
      hideGroup(c("Health facilities", "Pharmacies", "Addols", "Private facilities"))%>%
      # add legend to Est.
      addLegend(
        "bottomright",
        pal = qpal,
        values = ~col_select,
        title = NULL,
        opacity = 1
      )
    
  })
  
  # District map
  output$district_map <- renderLeaflet({
    
    # select data
    selected_data_dis <- switch(
      input$age_group_district,
      "15-49a"= dis_df_all,
      "15-24a"= dis_df_15_24
    )
    #selected_data_dis <- dis_df_15_24
    col_select_dis <- as.numeric(selected_data_dis[[input$district_mpcr]])
    
    labels <- sprintf(
      "<strong>%s</strong><br/>%g Users",
      selected_data_dis$NAME_2, col_select_dis
    ) %>% lapply(htmltools::HTML)
    
    
    bins <- seq(min(col_select_dis),max(col_select_dis),length=6)
    rounded_bins <- round(bins, -3)
    qpal <- colorBin("YlGnBu", bin=rounded_bins, col_select_dis)
    
    leaflet(selected_data_dis) %>%
      addTiles() %>%
      addPolygons(
        weight = 1, smoothFactor = 0.5,
        color = "gray",
        opacity = 1.0, fillOpacity = 0.8,
        highlightOptions = highlightOptions(
          color = "blue", weight = 2,
          bringToFront = TRUE
        ),
        fillColor = ~qpal(col_select_dis),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      # add legend to Est.
      addLegend(
        "bottomright",
        pal = qpal,
        values = ~col_select_dis, # Use col_select here to display actual numbers
        title = colnames(col_select_dis),
        opacity = 1,
      )
  })
}

# Run the Shiny app
shinyApp(ui, server)


