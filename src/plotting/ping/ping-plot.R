#!/usr/bin/env Rscript

##################################################
## Project: CaMCoW
## Script purpose: recursive ping ping traces
## Date: 25th of January 2018
## Author: Alvaro Garcia-Recuero
##################################################

# we'll use ggplot2 for plotting and reshape2 to get the data in shape
library(ggplot2)
library(reshape2)

# Function to plot one ping data frame as CDF
onecdfpingplot <- function(df) {
  # load the data
  df <- read.csv(file, as.is=T, skip = 1)
  # keep only the columns we want
  df <- df[,c(1,2,3)]
  # put the names back in
  names(df) <- c('Address','Sequence','Time')
  # print (head(df))
  # convert to long format
  df <- melt(df, id=c('Time'))
  head(df)
  # create the png nam
  name <- gsub(file, pattern='csv', replacement='pdf')
  # begin pdf output
  pdf(name)
  p <- ggplot(df, aes(Time)) + stat_ecdf(geom = "line") +
    labs(title="Empirical Cumulative Density Function for Ping",
         y = "F(x)", x="RTT in ms")
  # we have to explicitly print to pdf
  print(p)
  # finish output to pdf
  dev.off()
}

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
  # Iterate though destinations
  totald = NULL
  for (dest in destinations){
    totaln = NULL
    df_ping = NULL
    for (node in list.files(basedir, full.names=T)) {
      newping = NULL
      mypattern <- paste("^ping(.*)-", dest, "-.(.*)-out.csv", sep = "")
      logfiles <- dir(basedir, pattern = mypattern, recursive = TRUE, full.names = TRUE, ignore.case = TRUE)
      nodeid = basename(node)
      
      for (file in logfiles){
        # if there are logfiles for destination plot them, else throw error
        if(length(file) > 0){
          # loop through the files
          print (paste("Parsing", file, "ping files for", dest, sep = " "))
          ping <- read.csv(file, as.is=T,strip.white=TRUE,sep=',', header = TRUE)
          
          if(nrow(ping)>0){
            # Small hardcoding for experiment id 17313
            if(rootdir=='17313'){
              ping$dest <- dest
              ping$nodeid <- nodeid
              names(ping) <- c('address', 'sequence', 'time', 'dest', 'nodeid')
              # combine all and new dataframe
              newping <- ping
            }
            else{
              # combine dest and nodeid in ping dataframe
              address <- ping$address
              sequence <-ping$sequence
              time <-ping$time
              # combine all and new dataframe
              newping <- data.frame(address, sequence, time, dest, nodeid)
            }
            df_ping = rbind(df_ping, newping)
            
            # Save it in node data frame
            totaln <- rbind(totaln,df_ping)
            
            # Save it in all data frame
            totald <- rbind(totald,df_ping)
          }
        }
        else{
          next
        }
      }
    }
    if(length(totaln)>0){
      # Save as csv file
      write.csv(totaln, paste("dataset-ping-allnodes-target-", dest, "-experiment-", rootdir, ".csv", sep = ""), row.names=F)
      # Plottting all targets for 1 node
      totaln <- ggplot(totaln,aes(time))
      totaln <- totaln + stat_ecdf(geom = "line", aes(color=nodeid))
      totaln <- totaln + xlab("RTT in ms")
      totaln <- totaln + ylab("F(x)")
      totaln <- totaln + ggtitle(paste("CDF of Ping RTT for each node to target ", dest , sep=""))
      totaln <- totaln + theme_bw()
      totaln <- totaln + theme(legend.position="bottom", 
                               text=element_text(size=14), 
                               plot.title=element_text(face="bold", hjust = 0.5), 
                               axis.text.y=element_text(angle=50, vjust=0.5), 
                               axis.title.y = element_text(size = 10, vjust = 1))
      ggsave(paste("ping-allnodes-target-", dest, "-experiment-", rootdir, ".eps", sep = ""), totaln)
    }
  }
  if(length(totald)>0){
    # Save as csv file
    write.csv(totald, paste("dataset-ping-allnodes-alltargets-experiment-", rootdir, ".csv", sep = ""), row.names=F)
    # Plotting all traceroutes for all nodes by target
    totald <- ggplot(totald,aes(time))
    totald <- totald + stat_ecdf(geom = "line", aes(color=dest))
    totald <- totald + xlab("RTT in ms")
    totald <- totald + ylab("F(x)")
    totald <- totald + ggtitle("CDF of Hop Count Ping for all nodes by target")
    totald <- totald + theme_bw()
    totald <- totald + theme(legend.position="bottom", 
                             text=element_text(size=14), 
                             plot.title=element_text(face="bold", hjust = 0.5), 
                             axis.text.y=element_text(angle=50, vjust=1))
    ggsave(paste("ping-allnodes-alltargets", "-experiment-", rootdir, ".eps", sep = ""), totald)
  }
}