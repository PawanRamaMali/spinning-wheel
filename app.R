# Load packages
library(shiny)
library(shinyjs)
library(shinythemes)

options(shiny.maxRequestSize=3000*1024^2)

# Loader image
img_header <<- 'https://raw.githubusercontent.com/PawanRamaMali/spinning-wheel/master/loading.gif'
# Image Size
imgsize <- "auto 10%"


# Define UI
ui <- fluidPage(theme = shinythemes::shinytheme("sandstone"),
                useShinyjs(),
                extendShinyjs(script = "style.js",functions = "pageCol"),
                includeCSS("style.css"),
                singleton(tags$head(HTML(paste0("
                                  <style type='text/css'>
                                 
                                 
                                    
                                       #divLoading-header
                                  {
                                    display : none;
                                    }
                                    #divLoading-header.show
                                    {
                                        
                                  
                                        background-image : url('",img_header,"');
                                        background-size:", imgsize, ";

 
                                        
                                       position: absolute;
                                  
                                        transform: -50% -50%;
                                        left: 225px;
                                        right: 0;
                                        bottom: 0;
                                        top: 20px;
                                        width: 100%;
                                        background-size: 25px;
                                        background-repeat: no-repeat;
                                    }
                                    
                                    

                                    #loadinggif.show
                                    {
                                        left : 50%;
                                        top : 50%;
                                        position : absolute;
                                        z-index : 101;
                                        -webkit-transform: translateY(-50%);
                                        transform: translateY(-50%);
                                        width: 100%;
                                        margin-left : -16px;
                                        margin-top : -16px;
                                    }
                                    div.content {
                                                  width : 1000px;
                                                  height : 1000px;
                                    }
                                            
                             
                                  </style>")))),
    
    
               navbarPage(
                   
                   
                   
                        div(tags$div(style="margin-left:25px;margin-top: 8px; display:inline-block;",
                                       HTML("<a href='#' class='sidebar-toggle' style='color:#fff;', 
                                            data-toggle='offcanvas' role='button'><em class='fa fa-bars'></em>
                                            <span class='sr-only'>Toggle navigation</span></a>")),
                              div(id='divLoading-header')),
               
                
               tabPanel( "Import", 
                         fluidPage(
                             sidebarPanel( 
                                 
                                 fileInput('datafile', h4('Import File'),
                                           accept=c('*.*', 'text/comma-separated-values,text/plain'),width="100%"),
                                 actionButton("import","Import")
                             ),
                             # Output: Description, lineplot, and reference
                             mainPanel(
                                 tableOutput("table")
                             )
                         )
               )
    )
)
# Define server function
server <- function(input, output) {
    currentmodel <- reactiveValues()
    observeEvent(input$import, {
        if (is.null(input$datafile)) {
            data <- NULL
        } else {
            shinyjs::addClass('divLoading-header','show')
            
            inFile<-input$datafile
            data <-rio::import(inFile$datapath)
        }
        currentmodel$data <-data
        delay(1000,shinyjs::removeClass('divLoading-header','show'))
    },ignoreInit=TRUE)
    output$table<-renderTable({
        if(!is.null(currentmodel$data)){
            currentmodel$data
        } else {
            NULL
        }
       
    })
}

# Create Shiny object
shinyApp(ui = ui, server = server)