#to do
#Add current location, same as google #
#Update marker to include distance #
#Add table with N/S pointer or link to Gmaps

library(shiny)
library(leaflet)
library(shinyMobile)
#library(gmailr)
#library(tableHTML)


#gm_auth_configure(path = "google5.json")
#gm_auth(email = "barkerstu@gmail.com")


# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
    
    
    
    
    # # Create the map
    output$map <- renderLeaflet({
        leaflet() %>%
            addTiles(
                urlTemplate = "//{s}.tiles.mapbox.com/v3/jcheng.map-5ebohr46/{z}/{x}/{y}.png",
                attribution = 'Maps by <a href="http://www.mapbox.com/">Mapbox</a>'
                
            )
    })
    
    # Zoom in on user location if given
    observe({
        if(!is.null(input$lat)){
            map <- leafletProxy("map")
            dist <- 0.5
            lat <- input$lat
            lng <- input$long
            map %>% setView(lng, lat, zoom = 50) %>% addMarkers(input$long, input$lat)
        }
    })
    observeEvent(input$run, {
        print(as.character(input$id_text))
        print(as.character(input$id_note))
        print((input$lat))
        print((input$long))
        print(as.character(Sys.time()))
        
        md <- read.csv("id_output.csv")
        row_id <- nrow(md)+1
        id <- as.character(input$id_text)
        notes <- as.character(input$id_note)
        lat <- as.character(as.numeric(input$lat))
        lng <- as.character(as.numeric(input$long))
        time <- as.character(Sys.time())
        tmp <- data.frame(row_id,id,notes,lat,lng,time)
        md <- rbind(md, tmp)
        write.csv(md, "id_output.csv", row.names = F)
        
        #Set up
        
        #Create html table for email
        # msg = tableHTML(tmp)
        # 
        # email <- gm_mime() %>%
        #         gm_to("barkerstu@gmail.com") %>%
        #         gm_from("barkerstu@gmail.com") %>%
        #         gm_subject(paste(Sys.time(), row_id, "Survey", sep = "_")) %>%
        #         gm_html_body(paste0("<p> Survey Data </p>", msg))
        #     gm_send_message(email)
        #     print("e-mail sent")
        
        f7Notif(
            text = "Thanks",
            icon = f7Icon("bolt_fill"),
            title = "Message",
            subtitle = "Survey Submitted",
            titleRightText = "now",
            closeButton = T,
            session = session)
    })
})

