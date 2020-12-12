# First let's make a list of the outputs we want to render:
outputs_list <- list("word_document", "pdf_document", "powerpoint_presentation",
                     "ioslides_presentation", "slidy_presentation")# ADD THE REST HERE
# Because the .html files would be named the same and overwrite each other, 
# this for loop renames each one:
for (i in outputs_list){
  render("all_at_once/all_outputs.Rmd", 
         output_file = i)
}

# If you are not looking to output multiple files with the same file extension,
#you can simply do this instead (commented out because all outputs done above):
#rmarkdown::render("all_at_once/all_outputs.Rmd", 
#                  output_format = c("word_document", "pdf_document", "powerpoint_presentation"))