# CHANGES to the 'autpgrp' GAP package

## 1.11 (2022-08-05)

 - make global functions in this package read-only to prevent
   accidents caused by overwriting them with different code
 - update Max Horn's address

## 1.10.1 (2019-07-15)

 - fixed a manual example and the test derived from it to work
   with both GAP 4.11 and older GAP versions
 - made further janitorial changes

## 1.10 (2018-07-30)

 - added Max Horn as package maintainer
 - added this file with overview of changes in each package release
 - moved the internal function `InducedActionFactor` from the GAP
   library into this package
 - removed the internal function `BlockPosition`

## 1.9 (2018-03-07)

 - moved package to GitHub
 - removed some unused code
 - added automated test suite

## 1.8 (2016-11-25)

 - replaced use of obsolete GAP functions `MutableNullMat`,
   `MutableIdentityMat`, `NormedVectors` by `NullMat`, `IdentityMat`
   `NormedRowVectors`

## 1.7 (2016-11-20)

 - changed WedgePlusAction to deal separately with characteristic 2
 - added new undocumented functions `NumberOfClass2AssociativeAlgebras`
   and `NumberOfClass2AssocAlgebrasByDim`
 - improved orbit calculations to use dictionaries, which drastically improves
   performance for big orbits (but may slow down very small orbit computations
   a little bit)
 - replaced uses of `ConvertToMatrixRep` plus `Immutable` by `ImmutableMatrix`
 - updated some examples in the package manual; in particular, replaced use of
   `RequirePackage` by `LoadPackage`
 - cleaned up some code
 - stopped using the obsolete GAP variable `Revision`
 - removed CVS leftovers

## 1.6 (2012-05-29)

## 1.5 (2012-05-29)

## 1.4 (2009-08-31)

## 1.3 (2009-07-03)

## 1.2 (2002-11-19)
