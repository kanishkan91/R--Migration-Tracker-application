#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
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
# Define server logic required to draw a histogram
shinyServer(function(input,output,session){
  
  output$network <- renderVisNetwork({
    
    
    nodes <- read.csv("MigrateNodes1.csv", header=T, as.is=T)
    links <- read.csv("MigrateEdges1.csv", header=T, as.is=T)
    
    links<- subset(links, (links$Year==input$Year))
    if (input$Region=='ALL'){
    links<- subset(links,(links$Value>input$Numinp))
    print(links)}else{
    links2<-subset(links,(links$region_orig==input$Region))
    links3<-subset(links,(links$region_dest==input$Region))
    links4<- rbind(links2,links3)
    links5<- (unique(links4[,1:7]))
    links<- subset(links5,(links5$Value>input$Numinp))
    
    }
    nodes2<- subset(nodes,(nodes$Country %in% links$country_orig))
    nodes3<- subset(nodes,(nodes$Country %in% links$country_dest))
    nodes4<- rbind(nodes2,nodes3)
    nodes5<- (unique(nodes4[,1:3]))
    
    
    
    net <- graph_from_data_frame(d=links, vertices=nodes5, directed=T) 
    net<- simplify(net)
    
    
    vis.nodes<-data.frame(id=nodes5$Country,label=nodes5$Country,title=nodes5$Country,Color=nodes5$Color)
    if (input$check3==TRUE){
    vis.links<-data.frame(from=links$country_orig,to=links$country_dest,width=links$Value/200000,arrows=list(to=list(enabled=TRUE,scalefactor=0.5)))}else{
      
      vis.links<-data.frame(from=links$country_orig,to=links$country_dest,arrows=list(to=list(enabled=TRUE,scalefactor=0.5)))}
    
    
    vis.nodes$shape  <- c("dot")
    vis.nodes$shadow <- TRUE
    vis.nodes$title  <- nodes5$Country # Text on click
    vis.nodes$label  <- (vis.nodes$Country)
    if (input$checkbox==FALSE){
      deg <- degree(net, mode="in")}else
      {deg <- degree(net, mode="out")}
    if(input$check4==TRUE){
    vis.nodes$size   <- log(deg)*10
    vis.nodes$size[vis.nodes$size<8]<-8
    vis.nodes$size[vis.nodes$size>45]<-45}else{
      vis.nodes$size   <- (deg)*7
      vis.nodes$size[vis.nodes$size<8]<-8
      vis.nodes$size[vis.nodes$size>8]<-8  
    }
    vis.nodes$borderWidth <- 1
    vis.nodes$color.background <- nodes5$Color
    vis.nodes$color.border <- "black"
    vis.nodes$color.highlight.background <- "orange"
    vis.nodes$color.highlight.border <-"darkred"
    vis.links$title<- paste(links$country_orig," to",links$country_dest,"-",links$Value/1000000,"Mil people",sep=" ")
    vis.links$color<-links$Color
    vis.links$color.background<-links$Color
    legendnodes<-read.csv("Legend.csv")
    legendnodes<-data.frame(legendnodes)
    
    if (input$check2==FALSE){
    network<-visNetwork(vis.nodes,vis.links,height = "1500",
                        width = "1500")%>%
      visPhysics(stabilization=TRUE,minVelocity=14,maxVelocity=17,enabled = TRUE,solver ="forceAtlas2Based",adaptiveTimestep = TRUE,timestep = 0.10)%>%
      visEdges(smooth=FALSE)%>%
      visOptions(highlightNearest = TRUE, nodesIdSelection =FALSE,collapse=TRUE,selectedBy="id")%>%
      visIgraphLayout(layout = "layout_in_circle")%>%
      visLayout(randomSeed = 1234)%>%
      visInteraction(navigationButtons = TRUE)%>%
                       visLegend(ncol=1,useGroups = FALSE,addNodes = legendnodes,width=0.2,position="right",main="Legend")}else{
        network<-visNetwork(vis.nodes,vis.links,height = "1500",
                            width = "1500")%>%
          visPhysics(stabilization=TRUE,minVelocity=14,maxVelocity=17,enabled = TRUE,solver ="forceAtlas2Based",adaptiveTimestep = TRUE,timestep = 0.10)%>%
          visEdges(smooth=FALSE)%>%
          
          visOptions(highlightNearest = TRUE, nodesIdSelection =FALSE,collapse=TRUE,selectedBy="id")%>%
          visLayout(randomSeed = 1234)%>%
          visInteraction(navigationButtons = TRUE)%>%
          visLegend(ncol=1,useGroups = FALSE,addNodes = legendnodes,width=0.2,position="right",main="Legend")
      }
    
  }
  
  )}
)