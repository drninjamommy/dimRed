#' Plotting of dimRed* objects
#'
#' Plots a object of class dimRedResult and dimRedData
#'
#' somewhat inflexible, if you require custom colors or want to modify
#' graphical parameters, write your own plotting function.
#'
#' @param x dimRedResult/dimRedData class, e.g. output of
#'     embedded/loadDataSet
#' @param y Ignored
#' @param type plot type, one of \code{c("pairs", "parallel", "2d",
#'     "3d")}
#' @param col the columns of the meta slot to use for coloring, can be
#'     referenced as the column names or number of x@data
#' @param vars the axes of the embedding to use for plotting
#' @param ... handed over to the underlying plotting function.
#'
#' @examples
#' scurve = loadDataSet("3D S Curve")
#' plot(scurve, type = "pairs", main = "pairs plot of S curve")
#' plot(scurve, type = "parpl")
#' plot(scurve, type = "2vars", vars = c("y", "z"))
#'
#' @include mixColorSpaces.R
#' @include dimRedData-class.R
#' 
#' @export
setMethod(
    f = 'plot',
    signature = c('dimRedData', 'missing'),
    definition = function(x, y = NULL, type = "pairs",
                          vars = seq_len(ncol(x@data)),
                          col = seq_len(min(3, ncol(x@meta))), ...) {
        requireNamespace("MASS")
        requireNamespace("rgl")
        requireNamespace("graphics")
        requireNamespace("scatterplot3d")
        cols <- colorize(x@meta[,col])
        switch(
            type,
            "pairs"    = graphics::pairs(
               x@data[,vars],      col = cols,   ... ),
            "parpl"    = MASS::parcoord(
               x@data[,vars],      col = cols,   ... ),
            "2vars"    = graphics::plot(
               x@data[,vars[1:2]], col = cols,   ... ),
            "3vars"    = scatterplot3d::scatterplot3d(
               x@data[,vars[1:3]], color = cols, ... ),
            "3varsrgl" = rgl::points3d(
               x@data[,vars[1:3]], col = cols,   ... ),
            stop("wrong argument to plot.dimRedData")
        )
    }
)

#' @export
setMethod(
    f = 'plot',
    signature = c('dimRedResult', 'missing'),
    definition = function (x, y = NULL, type = "pairs",
                           vars = seq_len(ncol(x@data@data)),
                           col = seq_len(min(3, ncol(x@data@meta))), ...) {
        plot(x = x@data, type = type, vars = vars, col = col, ...)
    }
)