#!/usr/bin/Rscript
# setup filedir, title, cols, rows
cat("Set path to ATF file directory: ")
f.dir <- readLines(con="stdin", 1)
f.dir <- as.character(f.dir)

cat("Insert plot title: ")
p.title <- readLines(con="stdin", 1)
p.title <- as.character(p.title)

cat("Set label of Y axis: ")
y.lab <- readLines(con="stdin", 1)
y.lab <- as.character(y.lab)

cat("Set label of X axis: ")
x.lab <- readLines(con="stdin", 1)
x.lab <- as.character(x.lab)

cat("Set plots per Y axis for output file: ")
p.rows <- readLines(con="stdin", 1)
p.rows <- as.numeric(p.rows)

cat("Set plots per x axis for output file: ")
p.cols <- readLines(con="stdin", 1)
p.cols <- as.numeric(p.cols)

# building file index 
setwd(f.dir)
files <- c()
for (i in dir()) {	
	files = c(files, i) 
}

# echo and plotting all data
print("Plotting all Data...")

pdf(file="ALL_PLOTTED_DATA.pdf")
par(mfrow=c(p.rows,p.cols))
for (i in files) {
  xy <- read.table(i, sep="\t", skip=10, header=TRUE)
  xy_df <- data.frame(xy[1], xy[2])
  plot(xy_df, main=p.title, sub=paste("File: ", i),  xlab=x.lab, 
       ylab=y.lab, type="l")
  }
dev.off()

# echo
print("All data processed to the file ALL_PLOTTED_DATA.pdf in the directory of the atf files.")
