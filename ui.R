#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library("igraph")
library(ggplot2)
library(shiny)
library(visNetwork)
library(rsconnect)
library(dplyr)
library(shinyWidgets)


shinyUI(fluidPage(titlePanel("Migration Tracker Application"),
  sidebarLayout(
    sidebarPanel(
      checkboxInput("checkbox",label="Organize by outward migration (Current display is organized on the basis of inward migration) ",value=FALSE),
      checkboxInput("check2",label="Display Dynamically (When selected, displays graph as a network diagram)",value=FALSE),
      checkboxInput("check3",label="Highlight high value links",value=FALSE),
      checkboxInput("check4",label="Size nodes on the basis of number of connections (When unselected, all nodes are sized equally)",value=TRUE),
      numericInput("Numinp","Show migrants greater than", 10000),
      selectInput("Year","Select Decade for Display",choices=c("2005","2000","1995","2000")),
      selectizeInput("Region","Select Region",choices=c("North America","Africa","Europe","Fmr Soviet Union","West Asia","South Asia","South-East Asia","Oceania","Latin America","ALL"),selected="ALL")),
    mainPanel(p("This application tracks migration flows between countries during 3 decades."),
      visNetworkOutput("network",height = 800,width=800)) )))
  

