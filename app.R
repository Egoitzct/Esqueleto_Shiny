#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyFiles)
library(devtools)
install_github("https://github.com/Egoitzct/Esqueleto.git")
library(Esqueleto)

# Define UI for application that draws a histogram
ui <- fluidPage( 
    headerPanel(
        "Entrenamiento imágenes con 'Esqueleto'"
    ),
    sidebarPanel(
        tags$p("Pulsa el boton para seleccionar la carpeta\nen la que se encuentra tu base de datos.\n
               Asegúrate de seleccionar la carpeta en la que se encuentren únicamente las carpetas 'train', 'valid' y 'test'."),
        shinyDirButton("directory", "Elige tu carpeta", "Elige tu carpeta"),
        verbatimTextOutput("directorypath"),
        tags$hr(),
        tags$p("Selecciona el modelo que quieras usar de la siguiente lista:\n
               (Actualmente solo el modelo 'Alexnet')"),
        selectInput("modelo", " ", choices = c("Alexnet", "Resnet34", "Resnet50"), multiple = FALSE)
    ),
    mainPanel(
        tags$h2("Gráfico del modelo"),
        plotOutput("resultsPlot")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    volumes <- c(Home = fs::path_home(), "R Installation" = R.home(), getVolumes()())
    
    shinyDirChoose(input, "directory", roots= volumes, session = session)
    
    observe({
        cat("\ninput$directory value:\n\n")
        print(input$directory)
    })
    
    output$directorypath <- renderPrint({
        if (is.integer(input$directory)) {
            cat("No directory has been selected (shinyDirChoose)")
        } else {
            parseDirPath(volumes, input$directory)
        }
    })
    
    output$resultsPlot <- renderPlot({
        if (is.integer(input$directory) == FALSE) {
            path <- parseDirPath(volumes, input$directory)
        }
        
        p <- plot(image_train(path, model = input$model))
        print(p)
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
