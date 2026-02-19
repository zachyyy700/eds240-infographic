##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##                                                                            --
##----------------------- FUNCTION TO PARSE JRA MARGINS-------------------------
##                                                                            --
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Parse margin column as numeric
parse_margin <- function(margin) {
    # Handle Japanese chr cases, convert to numeric equivalent
    if (is.na(margin)) return(NA_real_)
    if (margin == "ハナ") return(0.05)
    if (margin == "アタマ") return(0.2)
    if (margin == "クビ") return(0.25)
    if (margin == "同着") return(0)
    
    # Replace period in margin value with a space 
    margin <- str_replace(margin,"\\.", " ")

    # Detect fraction margin value and convert to numeric value
    if (str_detect(margin,"/")) {
        parts <- str_split(margin, " ")[[1]]
        if (length(parts) == 2) {
            # Mixed fraction
            whole <- as.numeric(parts[1])
            frac <- str_split(parts[2],"/")[[1]]
            return(whole + as.numeric(frac[1]) / as.numeric(frac[2]))
        } else {
            # Single fraction
            frac <- str_split(parts[1], "/")[[1]]
            return(as.numeric(frac[1]) / as.numeric(frac[2]))
        }
    }
    # Otherwise just convert to numeric
    as.numeric(margin)
}