#' Just a dummy function
#'
#' @param x a value to add to y
#' @param y a value to add to x
#' @return the sum of x and y
#' @export

sum2 <- function(x, y){x + y}

#' Just another dummy function
#'
#' @param x a value
#' @param y a value
#' @return a data frame
#' @importFrom networkD3 JS forceNetwork
#' @export

dummyfun <- function(x, y)
{
  data.frame(x = x, y = y)
}


