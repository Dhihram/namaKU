#' Making acronym and sequence number from long name
#'
#'
#' @param df data frame that contains the long name
#' @param location the name of column that contain long name
#' @param vocal `TRUE` to keep vocal letter, `FALSE` to remove vocal letter
#' @param number number of letter to keep from each word
#' @param seq `TRUE` to add sequence number, `FALSE` to not add sequence number
#' @return a data frame containing the acronym name based on the parameters
#' @export
#'
#' @examples
#' # Load necessary packages
#' library(dplyr)
#' library(rlang)
#' # Assuming 'df' is your data frame and it has a column 'AreaName'
#' d <- data.frame(id = seq(1:3), AreaName = c("loNDON", "Port Alegre", 'MakaSSar'), sub = c('a', 'b', 'c'))
#' # Generate acronyms with sequence
#' d <- namaKU(df = d, location = AreaName, vocal = FALSE, number = 3, seq = TRUE)
#' # Check the results
#' d
namaKU <- function(df, location, vocal = TRUE, number = 3, seq = TRUE) {
  location <- ensym(location)

  # Check for NA values in the location column
  if (any(is.na(df[[rlang::as_name(location)]]))) {
    stop("Error: NA values detected in the location column. Please remove or impute them.")
  }

  # Function to generate acronyms
  generate_acronym <- function(area_name, vocal = TRUE, number = 3) {
    num <- ifelse(number > 4, 4, number)
    # Remove vowels if the vocal parameter is TRUE
    area_name <- ifelse(vocal == FALSE, gsub("[aeiouAEIOU]", "", area_name), area_name)

    # Split the area name into words
    words <- unlist(strsplit(area_name, "\\s+"))

    # Take the first 'number' words
    first_words <- head(words, number)

    # Extract the first 'number' letters from each word
    first_letters <- sapply(first_words, function(word) substr(word, 1, num))

    # Combine and return the acronym in uppercase
    acronym <- paste(toupper(first_letters), collapse = "")

    # Remove special characters
    acronym <- gsub("[^a-zA-Z]", "", acronym)

    return(acronym)
  }

  # Apply the function to generate acronyms and sequence numbers
  df_acronyms <- df %>%
    mutate(AcronymBase = sapply(!!location, generate_acronym, vocal = vocal, number = number)) %>%
    group_by(AcronymBase)

  if (seq == TRUE) {
    df_acronyms <- df_acronyms %>%
      mutate(Sequence = row_number(),
             acronym = paste(AcronymBase, Sequence, sep = "-")) %>%
      ungroup() %>%
      select(!!location, acronym)
  } else {
    df_acronyms <- df_acronyms %>%
      ungroup() %>%
      select(!!location, AcronymBase) %>%
      rename(acronym = AcronymBase)
  }

  # Merge the acronyms back with the original dataframe
  df <- df %>%
    left_join(df_acronyms, by = rlang::as_name(location))

  return(df)
}
