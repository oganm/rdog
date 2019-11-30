#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

#' @importFrom magrittr %<>%
#' @usage lhs \%<>\$ rhs
#' @keywords internal
NULL


#' @importFrom zeallot %<-%
NULL



#' Scale a vector to lie between a set interval
#'
#' A utility function to scale vectors to specific intervals.
#'
#' @param x vector to be scaled
#' @param min minimum value of the new interval
#' @param max maximum value of the new interval
#' @export
scale_to_int = function(x, min,max){
    scaleFun = scaleIntervals(max(x,na.rm = TRUE),min(x, na.rm=TRUE),max,min)
    scaleFun(x)
}

scaleIntervals = function(max,min,maxOut,minOut){
    a = (max - min)/(maxOut - minOut)
    b = max - maxOut*a
    if(a != 0){
        return(teval(paste0("function(x){(x - ",b,")/",a,'}')))
    }else{
        mean = (maxOut - minOut)/2
        return(teval(paste0("function(x){x[] = ",mean,";return(x)}")))
    }
}



teval = function (x, envir = parent.frame(),
                  enclos = if (is.list(envir) || is.pairlist(envir)) parent.frame() else baseenv())
{
    eval(parse(text = x), envir, enclos)
}

if(getRversion() >= "2.15.1"){
    utils::globalVariables(c(".","illoId","teval","frontFace"))
}

