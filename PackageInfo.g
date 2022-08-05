#############################################################################
##
##  PackageInfo.g for the package `AutPGrp'                      Bettina Eick
##

SetPackageInfo( rec(

PackageName := "AutPGrp",
Subtitle := "Computing the Automorphism Group of a p-Group",
Version := "1.11",
Date := "05/08/2022", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
      LastName      := "Eick",
      FirstNames    := "Bettina",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "beick@tu-bs.de",
      WWWHome       := "http://www.iaa.tu-bs.de/beick",
      PostalAddress := Concatenation(
               "Institut Analysis und Algebra\n",
               "TU Braunschweig\n",
               "Universitätsplatz 2\n",
               "D-38106 Braunschweig\n",
               "Germany" ),
      Place         := "Braunschweig",
      Institution   := "TU Braunschweig"),

    rec(
      LastName      := "Horn",
      FirstNames    := "Max",
      IsAuthor      := false,
      IsMaintainer  := true,
      Email         := "horn@mathematik.uni-kl.de",
      WWWHome       := "https://www.quendi.de/math",
      PostalAddress := Concatenation(
                         "Fachbereich Mathematik\n",
                         "TU Kaiserslautern\n",
                         "Gottlieb-Daimler-Straße 48\n",
                         "67663 Kaiserslautern\n",
                         "Germany" ),
      Place         := "Kaiserslautern, Germany",
      Institution   := "TU Kaiserslautern"
    ),

    rec(
      LastName      := "O'Brien",
      FirstNames    := "Eamonn",
      IsAuthor      := true,
      IsMaintainer  := false,
      Email         := "obrien@math.auckland.ac.nz",
      WWWHome       := "http://www.math.auckland.ac.nz/~obrien",
      PostalAddress := Concatenation(
            "Department of Mathematics\n",
            "University of Auckland\n",
            "Private Bag 92019\n Auckland\n New Zealand\n" ),
      Place         := "Auckland",
      Institution   := "University of Auckland"
    ),
],

Status := "accepted",
CommunicatedBy := "Derek F. Holt (Warwick)",
AcceptDate := "09/2000",

PackageWWWHome  := "https://gap-packages.github.io/autpgrp/",
README_URL      := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL  := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
SourceRepository := rec(
    Type := "git",
    URL := "https://github.com/gap-packages/autpgrp",
),
IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                 "/releases/download/v", ~.Version,
                                 "/autpgrp-", ~.Version ),
ArchiveFormats := ".tar.gz",

AbstractHTML :=
"The <span class=\"pkgname\">AutPGrp</span> package introduces a new function to compute the automorphism group of a finite $p$-group. The underlying algorithm is a refinement of the methods described in O'Brien (1995). In particular, this implementation is more efficient in both time and space requirements and hence has a wider range of applications than the ANUPQ method. Our package is written in GAP code and it makes use of a number of methods from the GAP library such as the MeatAxe for matrix groups and permutation group functions. We have compared our method to the others available in GAP. Our package usually out-performs all but the method designed for finite abelian groups. We note that our method uses the small groups library in certain cases and hence our algorithm is more effective if the small groups library is installed.",

PackageDoc := rec(
  BookName  := "AutPGrp",
  ArchiveURLSubset := ["doc", "htm"],
  HTMLStart := "htm/chapters.htm",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Computing the Automorphism Group of a p-Group",
  Autoload  := true),

Dependencies := rec(
  GAP := ">=4.7",
  NeededOtherPackages := [],
  SuggestedOtherPackages := [],
  ExternalConditions := [] ),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

Keywords := ["p-group", "automorphism group"]

));


