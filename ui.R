################################################################################
#
#                               Shiny user interface (ui)
#
################################################################################
### Install packages if necessary

if(!require("shiny")) install.packages("shiny")
if(!require("shinythemes")) install.packages("shinythemes")
if(!require("shinyjs")) install.packages("shinyjs")
if(!require("markdown")) install.packages("markdown")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("gridExtra")) install.packages("gridExtra")

### Load required packages

library(shiny)
library(shinythemes)
library(markdown)
library(ggplot2)
library(gridExtra)

library(shinyjs)
### Begin ui -------------------------------------------------------------------

shinyUI(
  fluidPage(
    useShinyjs(),
    theme = "stylesheet.css",
    
### Header -----------------------------------------------------------------

    fluidRow(# div(id="titlebar","Verteilungsfunktionen und Hypothesentests"),
      div(id = "spacer",
        div(id = "titlebar",br(),"Wahrscheinlichkeitsverteilungen",br()," "),
        br(),
        includeHTML("www/lehrstuhl.html"),
        tags$head(
          tags$link(href = "favicon.ico",
                    rel = "stylesheet")
        )
      )),

    sidebarLayout(
      
### Sidebar panel ----------------------------------------------------------

      sidebarPanel(
        width = 3,
        tabsetPanel(
          tabPanel(
            "Verteilungen",
            fluidRow(
              helpText("1. Wähle eine Verteilung"),
              selectInput('dist', NULL, list(
                "Stetige Verteilungen" = c('Normalverteilung', 
                                           't-Verteilung',
                                           'Chi-Quadrat-Verteilung', 
                                           'F-Verteilung', 
                                           'Exponentialverteilung',
                                           'Stetige Gleichverteilung'),
                "Diskrete Verteilungen" = c('Binomialverteilung',
                                            'Poisson-Verteilung')
                )
              )
              ), # END fluidRow 

            ### Conditonal Panels ----------------------------------------------------------
            fluidRow(
            conditionalPanel("input.dist == 'Normalverteilung'",
                             helpText("2. Wähle die Parameter der Verteilung."),
                             numericInput(inputId = 'mu', label = '\\(\\mu\\)', value = 0, step = 0.1), 
                             numericInput(inputId = 'sigma', label = '\\(\\sigma\\)', value = 1, min = 0, step = 0.1),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.norm", label = NULL, min = -50, max = 50, value = c(-5, 5))),
            conditionalPanel("input.dist == 't-Verteilung'",
                             helpText("2. Wähle den Parameter der Verteilung."),
                             numericInput(inputId = 'df.t',label = '\\(k\\)', value = 5, min = 0),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.t", label = NULL, min = -50, max = 50, value = c(-5, 5))),
            conditionalPanel("input.dist == 'Chi-Quadrat-Verteilung'",
                             helpText("2. Wähle den Parameter der Verteilung."),
                             numericInput(inputId = 'df.chi',label = '\\(k\\)', value = 3, min = 0),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.chi", label = NULL, min = -1, max = 100, value = c(0, 10))),
            conditionalPanel("input.dist == 'F-Verteilung'",
                             helpText("2. Wähle die Parameter der Verteilung."),
                             numericInput(inputId = 'df1',label = '\\(k_1\\)', value = 10, min = 0),
                             numericInput(inputId = 'df2',label = '\\(k_2\\)', value = 5, min = 0),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.f", label = NULL, min = -0, max = 50, value = c(0, 5))),
            conditionalPanel("input.dist == 'Exponentialverteilung'",
                             helpText("2. Wähle den Parameter der Verteilung."),
                             numericInput(inputId = 'rate',label = '\\(\\alpha\\)', value = 1, min = 0, step = 0.1),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.exp", label = NULL, min = -1, max = 100, value = c(0, 5))),
            conditionalPanel("input.dist == 'Stetige Gleichverteilung'",
                             helpText("2. Wähle die Parameter der Verteilung."),
                             sliderInput("axis.updown", label = "\\(a\\) und \\(b\\)", 
                                         min = -50, max = 50, value = c(-5, 5)),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.cu", label = NULL, min = -50, max = 50, value = c(-10, 10))),
            conditionalPanel("input.dist == 'Binomialverteilung'",
                             helpText("2. Wähle die Parameter der Verteilung."),
                             numericInput(inputId = 'size',label = '\\(n\\)', 
                                          value = 5, min = 0, step = 1),
                             numericInput(inputId = 'prob',label = '\\(p\\)', 
                                          value = 0.5, min = 0, max = 1, step = 0.1),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.bin", label = NULL, min = 0, max = 100, value = c(0, 10))),
            conditionalPanel("input.dist == 'Poisson-Verteilung'",
                             helpText("2. Wähle den Parameter der Verteilung."),
                             numericInput(inputId = 'lambda',label = '\\(\\lambda\\)', value = 1, min = 0, step = 0.1),
                             helpText("3. Wähle den gewünschten x-Achsenbereich"),
                             sliderInput("axis.pois", label = NULL, min = 0, max = 100, value = c(0, 10)))
            ), # end fluidRow
            br(),
            fluidRow(
                helpText("4.1 Welche Werte sollen berechnet werden"),
                selectInput('distquant', NULL,
                            c('Keine',
                              'Wert der Dichtefunktion',
                              'Wert der Wahrscheinlichkeitsfunktion',
                              'Wert der Verteilungsfunktion',
                              'Wert der Quantilsfunktion')),
                conditionalPanel("input.distquant == 'Wert der Wahrscheinlichkeitsfunktion'",
                                 helpText("4.2 Für welches x soll der Wert
                                          der Wahrscheinlichkeitsfunktion berechnet werden?"),
                                 numericInput("prob.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Wert der Dichtefunktion'",
                                 helpText("4.2 Für welches x soll der Wert
                                          der Dichtefunktion berechnet werden?"),
                                 numericInput("dens.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Wert der Verteilungsfunktion'",
                                 helpText("4.2 Für welches x soll der Wert
                                          der Verteilungsfunktion berechnet werden?"),
                                 numericInput("dist.value", NULL, value = 0)
                                 ),
                conditionalPanel("input.distquant == 'Wert der Quantilsfunktion'",
                                 helpText("4.2 Für welche Wahrscheinlichkeit soll der Wert
                                          der Quantilsfunktion berechnet werden?"),
                                 numericInput("quant.prob", NULL, value = 0.5, min = 0, max = 1, step = 0.1)
                                 )
            ) # END fluidRow
          ), # tabPanel
          tabPanel("Hypothesentests",
                   helpText("1. Wähle die Art des Tests"),
                   selectInput('test.type', NULL, c('Rechtsseitig', 'Linksseitig', 'Zweiseitig')),
                   helpText("2. Wähle das gewünschte Signifikanzniveau"),
                   numericInput("sig.niveau", NULL, value = 0.05, min = 0, max = 1, step = 0.1),
                   helpText("3. Ablehnungsbereich einzeichnen ?"),
                   checkboxInput('crit.value.checkbox', label = "Ja", value = F)
          ) # END tabPanel
        ) # END tabsetPanel
        ), # END sidebarLayout

### MainPanel ------------------------------------------------------------------
      
      mainPanel(
        
        plotOutput('plot'),
        br(),
        uiOutput("ddq"),
        uiOutput("crit.value.text"),
        br(),
        uiOutput('dist.info')
        
        ) # END mainPanel
    ) # END sidebar layout
  ) # END fluid page
) # END shiny ui