## LinOp class shadowing CPP class
CVXcanon.LinOp <- R6::R6Class("CVXcanon.LinOp",
                              private = list(
                                  operatorType = c( ## from LinOp.hpp
                                      "VARIABLE",
                                      "PROMOTE",
                                      "MUL",
                                      "RMUL",
                                      "MUL_ELEM",
                                      "DIV",
                                      "SUM",
                                      "NEG",
                                      "INDEX",
                                      "TRANSPOSE",
                                      "SUM_ENTRIES",
                                      "TRACE",
                                      "RESHAPE",
                                      "DIAG_VEC",
                                      "DIAG_MAT",
                                      "UPPER_TRI",
                                      "CONV",
                                      "HSTACK",
                                      "VSTACK",
                                      "SCALAR_CONST",
                                      "DENSE_CONST",
                                      "SPARSE_CONST",
                                      "NO_OP",
                                      "KRON",
                                      "EQ",
                                      "LEQ",
                                      "SOC",
                                      "EXP",
                                      "SDP"),
                                  args = NA,
                                  pkg = NA,
                                  myClassName = NA,
                                  ptr = NA
                              ),
                              active = list(
                                  sparse = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_sparse",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                      } else {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_sparse",
                                                                   thisPkg = private$pkg)
                                          ## value should be a boolean
                                          .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                      }
                                  }
                                 ,
                                  sparse_data = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_sparse_data",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                      } else {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_sparse_data",
                                                                   thisPkg = private$pkg)
                                          ## value should be a dgCMatrix-class
                                          .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                      }
                                  }
                                 ,
                                  dense_data = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_dense_data",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                      } else {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_dense_data",
                                                                   thisPkg = private$pkg)
                                          ## value should be a matrix
                                          .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                      }
                                  }
                                 ,
                                  type = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_type",
                                                                   thisPkg = private$pkg)
                                          index <- .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                          ## make 1-based index
                                          private$operatorType[index + 1]
                                      } else {
                                          ##value <- match.arg(value, private$operatorType)
                                          ## Make zero based index!
                                          index <- match(value, private$operatorType) - 1
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_type",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, index, PACKAGE = private$pkg)
                                      }
                                  }
                                 ,
                                  size = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_size",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                      } else {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_size",
                                                                   thisPkg = private$pkg)
                                          ## value is an integer vector
                                          .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                      }
                                  }
                                 ,
                                  slice = function(value) {
                                      if (missing(value)) {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "get_slice",
                                                                   thisPkg = private$pkg)
                                          .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                      } else {
                                          rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                                   methodName = "set_slice",
                                                                   thisPkg = private$pkg)
                                          ## value is a list of integer vectors
                                          .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                      }
                                  }
                              ),
                              public = list(
                                  initialize = function(type = NULL, size = NULL, args = NULL, data = NULL) {
                                      private$args = R6List$new()
                                      private$pkg <- pkg <- getPackageName()
                                      private$myClassName <- myClassName <- class(self)[1]
                                      ## Create a new LinOp on the C side
                                      private$ptr <- .Call(rcppMungedName(cppClassName = myClassName,
                                                                          methodName = "new",
                                                                          thisPkg = pkg),
                                                           PACKAGE = pkg)
                                      ## Associate args on R side with the args on the C side.
                                      ##browser()
                                      if (!is.null(type)) {
                                          self$type <- type
                                      }
                                      if (!is.null(size)) {
                                          self$size <- size
                                      }
                                      if (!is.null(args)) {
                                          for (x in args) self$args_push_back(x)
                                      }
                                      if (!is.null(data)) {
                                          self$dense_data <- data
                                      }
                                  }
                                 ,
                                  args_push_back = function(R6LinOp) {
                                      private$args$append(R6LinOp)
                                      rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                               methodName = "args_push_back",
                                                               thisPkg = private$pkg)
                                      .Call(rcppFn, private$ptr, R6LinOp$getXPtr(), PACKAGE = private$pkg)
                                  }
                                 ,
                                  getXPtr = function() {
                                      private$ptr
                                  }
                                  ,
                                  getArgs = function() {
                                      private$args
                                  }
                                 ,
                                  get_id = function() {
                                      rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                               methodName = "get_id",
                                                               thisPkg = private$pkg)
                                      .Call(rcppFn, private$ptr, PACKAGE = private$pkg)
                                  }
                                  ,
                                  size_push_back = function(value) {
                                      rcppFn <- rcppMungedName(cppClassName = private$myClassName,
                                                               methodName = "size_push_back",
                                                               thisPkg = private$pkg)
                                      .Call(rcppFn, private$ptr, value, PACKAGE = private$pkg)
                                  }
                                 ,
                                  toString = function() {
                                      sparse <- self$sparse
                                      if (sparse) {
                                          data <- paste(self$sparse_data, collapse=", ")
                                      } else {
                                          data <- paste(self$dense_data, collapse=", ")
                                      }
                                      sprintf("LinOp(id=%s, type=%s, size=[%s], args=%s, sparse=%s, data=[%s])",
                                              self$get_id(),
                                              self$type,
                                              paste(self$size, collapse=", "),
                                              private$args$toString(),
                                              sparse,
                                              data)
                                  }
                                 ,
                                  print = function() {
                                      print(self$toString())
                                  }

                              ))
