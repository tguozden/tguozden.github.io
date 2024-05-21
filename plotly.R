library(ggplot2)
library(reticulate)
library(lubridate)
library(plotly)
library(htmlwidgets)

use_python("/usr/bin/python")
Pd <- import("pandas")
source_python("/home/atom/Documents/flexdashboards/miprimer/lee_pickle.py")
datapath = '/home/atom/Documents/flexdashboards/miprimer/data/'

codigos = c( 'IDEPAR138', 'IDEPAR123', 'ISANCA4', 'IDEPAR123')
data_frames <- list()
for (file in codigos) {
  df <-py_to_r(lee_pickle(datapath, file, 'LOPEZ'))
  df$name <- file
  data_frames[[file]] <- df
}


combined_data <- do.call(rbind, data_frames)
p <- ggplot(data = combined_data, aes(x = as_datetime(obsTimeLocal, tz = 'America/Argentina/Buenos_Aires'), 
                          y = temp, color = name, text = paste(
                          as.Date(obsTimeLocal)) )) +    #de alguna manera inserta un nan que corta la línea
  geom_line() + xlab('hora') + geom_hline(yintercept = 0, alpha = 0.3)


ply <- ggplotly(p, tooltip = FALSE, dynamicTicks = TRUE) %>% partial_bundle(local = FALSE)
htmlwidgets::saveWidget(ply, file = "mi3doggplot.html", selfcontained = F, libdir = "lib")