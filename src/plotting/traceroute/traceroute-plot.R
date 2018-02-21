#!/usr/bin/env Rscript

##################################################
## Project: CaMCoW
## Script purpose: recursive parsing of traceroute logs
## Date: 25th of January 2018
## Author: Alvaro Garcia-Recuero
##################################################

# we'll use ggplot2 for plotting and reshape2 to get the data in shape
list.of.packages <- c("ggplot2", "reshape2", "dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages, dependencies=TRUE)

library(ggplot2)
library(reshape2)
library(dplyr)

# Define list of destinations
destinations <- c("google.com", "youtube.com", "facebook.com", "baidu.com", "wikipedia.org", 
                  "reddit.com", "yahoo.com", "google.co.in", "qq.com", "amazon.com")
# "nytimes.com","theatlantic.com", "breitbart.com", "cnn.com", "twitter.com", "reddit.com"

# Test if there is at least one argument: if not, return an error
if (length(args)==0) {
  stop("At least one argument must be supplied (input file).n", call.=FALSE)
}else if (length(args)==1) {
  # set path to files
  args = commandArgs(trailingOnly=TRUE)
  basedir=args[1]
  rootdir=basename(basedir)
  
  # iterate through destination
  totald = NULL
  for (dest in destinations){
    # Iterate through nodes
    totaln = NULL
    df_node = NULL
    for(node in list.files(basedir, full.names=T)){
      # get log file
      mypattern <- paste("^traceroute.(.*)-", dest, "-.(.*)-out.log", sep = "")
      logfiles <- dir(node, pattern = mypattern, recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
      nodename = basename(node)
      
      for (file in logfiles){
        # convert .log to .csv for each file in each node
        myarg <- print(file)
        cmd <- paste("perl", "traceroute_parse.pl", myarg)
        system(cmd)
        
        # find patterns that we converted
        csvpattern <- paste("^traceroute.(.*)-", dest, "-.(.*)-out.csv", sep = "")
        csvfilesdest <- dir(node, pattern = csvpattern, recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
        
        # if there are logfiles for the node, plot them, else throw error
        if(length(csvfilesdest) > 0){
          # loop through the files in each node
          for (file in csvfilesdest){
            print (paste("Parsing",file," traceroute file", dest, sep = " "))
            traceroute <- read.csv(file, as.is=T,strip.white=TRUE,sep=',', header = TRUE)
            
            # Get last row with an IP in it
            iplistwithstars <- traceroute$IP
            re <- regexpr(
              "(?(?=.*?(\\d+\\.\\d+\\.\\d+\\.\\d+).*?)(\\1|))",
              iplistwithstars, perl = TRUE)
            # print(re)
            capture_last_hop <- attr(re, 'capture.start')
            
            # Check if tracer is not empty (all stars)
            if(max(which(capture_last_hop[,1] == TRUE))>0){
              # combine data frames
              hops <- max(which(capture_last_hop[,1] == TRUE))
              df_node = rbind(df_node, data.frame(hops, nodename, dest))
              
              # the magic:
              df_node <- do.call(data.frame, lapply(df_node, function(x) {
                replace(x, is.infinite(x) | is.na(x), 0)
              })
              )
              
              print("Dataframe with a target for each node")
              print(head(df_node))
              
              # Save it in node data frame
              totaln <- rbind(totaln,df_node)
              
              # Save it in all data frame
              totald <- rbind(totald,df_node)
            }
            else{
              next
            }
          }
          
        }
        else{
          next
        }
      }
    }
    if(length(totaln)>0){
      # Save as csv file
      write.csv(totaln, paste("dataset-traceroute-allnodes-target-", dest, "-experiment-", rootdir, ".csv", sep = ""), row.names=F)
      # Plottting all targets for 1 node
      print(head(totaln))
      totaln <- ggplot(totaln,aes(hops))
      totaln <- totaln + stat_ecdf(geom = "line", aes(color=nodename))
      totaln <- totaln + xlab("Hop count")
      totaln <- totaln + ylab("F(x)")
      totaln <- totaln + ggtitle(paste("CDF of Hop Count Traceroute for target ", dest , sep="")) 
      totaln <- totaln + theme_bw()
      totaln <- totaln + theme(legend.position="bottom", 
                               text=element_text(size=14), 
                               plot.title=element_text(face="bold", hjust = 0.5), 
                               axis.text.y=element_text(angle=50, vjust=0.5), 
                               axis.title.y = element_text(size = 10, vjust = 1))
      ggsave(paste(basedir,"/traceroute-allnodes-target-", dest,"-experiment-", rootdir, ".eps", sep = ""), totaln)
    }
  }
  if(length(totald)>0){
    # Save as csv file
    write.csv(totald, paste("dataset-traceroute-allnodes-alltargets-experiment-", rootdir, ".csv", sep = ""), row.names=F)
    names(totald) <- c('hops', 'nodename', 'dest')
    # Plottting all traceroutes for all nodes by target
    totald <- ggplot(totald,aes(hops))
    totald <- totald + stat_ecdf(geom = "line", aes(color=dest))
    totald <- totald + xlab("Hop count")
    totald <- totald + ylab("F(x)")
    totald <- totald + ggtitle("CDF of Hop Count Traceroute by target") 
    totald <- totald + theme_bw()
    totald <- totald + theme(legend.position="bottom", 
                             text=element_text(size=14), 
                             plot.title=element_text(face="bold", hjust = 0.5), 
                             axis.text.y=element_text(angle=50, vjust=1))
    ggsave(paste(basedir,"/traceroute-allnodes-alltargets.eps", sep = ""), totald)
  }
}